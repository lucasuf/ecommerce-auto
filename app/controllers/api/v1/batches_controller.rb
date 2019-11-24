=begin 
1. Create a Batch
We need a way to create a Batch and pass those Orders to the production status. 
We should input the Purchase Channel and receive back the Reference of the created Batch 
along with the number of Orders that were included.

2. Produce a Batch
Pass a Batch from production to closing using reference number.

3. Send a Batch
We also need a way to input a Batch and a Delivery Service and those Orders should be marked as sent.

=end
module Api
    module V1
        class BatchesController < ApplicationController
            # While authetication process is not implemented
            skip_before_action :verify_authenticity_token
            def index
                @batches = Batch.order('created_at DESC')
                render json: {status: 'SUCCESS', message:'List of orders', data:@batches}
            end
            def create
                batch = Batch.new(batch_params)
                # Setting reference number
                batch[:reference_batch] = Faker::Code.nric

                # Getting all orders for purchase_channel
                orders = Order.where("purchase_channel = ?", batch[:purchase_channel_batch])
                if batch.save
                    # Setting batch id in orders
                    orders.update(batch_id: batch[:id])
                    # Changing orders status
                    orders.update(status: Order.statuses['production'])
					render json: {status: 'SUCCESS', message: 'Saved Batch', number_of_orders_in_batch: orders.size, data: batch}, status: :ok
				else
					render json: {status: 'ERROR', message: 'Batch not saved', data:batch.errors}, status: :unprocessable_entity
				end
            end

            def update
                batch = Batch.where("reference_batch = ?", params[:reference_batch])
                if params[:action_batch] == "Close"
                    # Find all orders for this batch id
                    orders = Order.where("batch_id = ?", batch[0].id)
                    # Update status of orders to closing
                    orders.update(status: Order.statuses['closing'])
                    render json: {status: 'SUCCESS', message: 'Orders closed for batch', number_of_orders_in_batch: orders.size, data: batch}, status: :ok
                elsif params[:action_batch] == "Send"
                    if params[:delivery_service]
                        # Find all orders for this batch id and delivery service
                        orders = Order.where("batch_id = ? AND delivery_service = ?", batch[0].id, params[:delivery_service])
                        # Update status of orders to sent
                        orders.update(status: Order.statuses['sent'])
                        render json: {status: 'SUCCESS', message: 'Orders sent for batch', delivery_service_sent: params[:delivery_service], number_of_orders_in_sent: orders.size, data: batch}, status: :ok
                    else
                        render json: {status: 'ERROR', message: 'Please provide a delivery service!!'}
                    end
                else
                    render json: {status: 'ERROR', message: 'I do not know this action!!'}
                end
            end

            private
            def batch_params
                params.permit(:purchase_channel_batch)
            end

            private
            def update_params
                params.permit(:action_batch, :delivery_service )
            end
        end
    end
end
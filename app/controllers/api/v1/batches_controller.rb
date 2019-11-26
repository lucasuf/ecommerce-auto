module Api
    module V1
        class BatchesController < ApplicationController
            before_action :authenticate_user!, except: :index
            
            # List all batches
            def index
                @batches = Batch.order('created_at DESC')
                render json: {status: 'SUCCESS', message:'List of batches', data:@batches}
            end

            # Create a new batch for given purchase_channel
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
            
            # Update batch status for reference_batch
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
=begin 
1. Create a Batch
We need a way to create a Batch and pass those Orders to the production status. 
We should input the Purchase Channel and receive back the Reference of the created Batch 
along with the number of Orders that were included.
=end
module Api
    module V1
        class BatchesController < ApplicationController
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
					render json: {status: 'SUCCESS', message: 'Saved order', number_of_orders_in_batch: orders.size, data: batch}, status: :ok
				else
					render json: {status: 'ERROR', message: 'Bat not saved', data:batch.errors}, status: :unprocessable_entity
				end
            end
            private
            def batch_params
                params.permit(:purchase_channel_batch)
            end
        end
    end
end
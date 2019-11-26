module Api
    module V1
        class OrdersController < ApplicationController
            before_action :authenticate_user!, except: [:index, :show]
            
            # List orders according with query
            def index
                # Checking orders for a specific client
                if params[:client_name]
                    @orders = Order.where("client_name = ?", params[:client_name])
                    render json: {status: 'SUCCESS', message:'List of orders for specific client', data:@orders}
                
                # Checking orders for purchase_channel and status
                elsif params[:purchase_channel]
                    if params[:status]
                        @orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], Order.statuses[params[:status]])
                        render json: {status: 'SUCCESS', message:'List of orders using status and purchase channel', data:@orders}
                    else
                        @orders = Order.where("purchase_channel = ?", params[:purchase_channel])
                        render json: {status: 'SUCCESS', message:'List of orders using purchase channel', data:@orders}
                    end
                
                # Checking Financial report. For test use test parameter. Else it will render on index view
                else
                    if params[:report] == 'yes'
                        @orders_by_channel =  Order.distinct(:purchase_channel).group(:purchase_channel).count
                        @total_value_by_channel =  Order.distinct(:purchase_channel).group(:purchase_channel).sum(:total_value)
                        render json: {status: 'SUCCESS', message:'Finacial Report', orders_by_channel:@orders_by_channel, total_value_by_channel:@total_value_by_channel }
                    elsif params[:test] == 'yes'
                        @orders = Order.order('created_at DESC')
                        render json: {status: 'SUCCESS', message:'List of orders', data:@orders}
                    else
                        @orders = Order.order('created_at DESC')                        
                    end
                end
            end

            # Showing specific order by id
            def show
				order = Order.find(params[:id])
				render json: {status: 'SUCCESS', message:'Loaded order.', data:order},status: :ok
			end

            # Create a new order
            def create
                order = Order.new(order_params)
				if order.save
					render json: {status: 'SUCCESS', message: 'Saved order', data: order}, status: :ok
				else
					render json: {status: 'ERROR', message: 'Order not saved', data:order.errors}, status: :unprocessable_entity
				end
            end
            
            # Destroy an order using id
            def destroy
				order = Order.find(params[:id])
				order.destroy
				render json: {status: 'SUCCESS', message: 'Deleted order.', data: order}, status: :ok
            end
            
            # Update an order using id
            def update
                order = Order.find(params[:id])
                if order.update(order_params)
                  render json: {status: 'SUCCESS', message:'Updated order', data:order},status: :ok
                else
                  render json: {status: 'ERROR', message:'Order not updated', data:order.errors},status: :unprocessable_entity
                end
            end

            private
            def order_params
                params.permit(:reference, :purchase_channel, :client_name, :adress, :delivery_service, :total_value, :line_items)
            end
        end
    end    
end
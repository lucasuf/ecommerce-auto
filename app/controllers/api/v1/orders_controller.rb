# ---------------------------------------------------------- #
# This class will define all methods for Order controller. 
# It will be defined thet following end points:
    # index: REST API for working with the orders:
    #       to get orders for specfic client example: /api/v1/orders?client_name=Lucas
    #       to get orders for a channel example: /api/v1/orders?purchase_channel=Site%20BR
    #       to get orders for a channel passing status example: /api/v1/orders?purchase_channel=Site%20BR&status=production
    # show: show order by id
    # create: Create a new order
    # destroy: Delete an order
    # update: To update values from an order
# ---------------------------------------------------------- #
module Api
    module V1
        class OrdersController < ApplicationController
            def index
                # Optional action. Just for example purpose.
                #orders = Order.order('created_at DESC')
                #render json: {status: 'SUCCESS', message:'List of orders', data:orders}
                if params[:client_name]
                    #http://localhost:3000/api/v1/orders?client_name=Lucas
                    @orders = Order.where("client_name = ?", params[:client_name])
                    render json: {status: 'SUCCESS', message:'List of orders for specific client', data:@orders}
                elsif params[:purchase_channel]
                    if params[:status]
                        #http://localhost:3000/api/v1/orders?purchase_channel=Site%20BR&status=production
                        @orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], Order.statuses[params[:status]])
                        render json: {status: 'SUCCESS', message:'List of orders', data:@orders}
                    else
                        #http://localhost:3000/api/v1/orders?purchase_channel=Site%20BR
                        @orders = Order.where("purchase_channel = ?", params[:purchase_channel])
                        render json: {status: 'SUCCESS', message:'List of orders', data:@orders}
                    end
                else
                    @orders = Order.order('created_at DESC')
                    render json: {status: 'SUCCESS', message:'List of orders', data:@orders}
                end
            end

            def show
				order = Order.find(params[:id])
				render json: {status: 'SUCCESS', message:'Loaded order.', data:order},status: :ok
			end

            def create
                order = Order.new(order_params)
				if order.save
					render json: {status: 'SUCCESS', message: 'Saved order', data: order}, status: :ok
				else
					render json: {status: 'ERROR', message: 'Order not saved', data:order.errors}, status: :unprocessable_entity
				end
            end

            def destroy
				order = Order.find(params[:id])
				order.destroy
				render json: {status: 'SUCCESS', message: 'Deleted order.', data: order}, status: :ok
            end
            
            def update
                article = Article.find(params[:id])
                if article.update_attributes(article_params)
                  render json: {status: 'SUCCESS', message:'Updated order', data:article},status: :ok
                else
                  render json: {status: 'ERROR', message:'Order not updated', data:article.errors},status: :unprocessable_entity
                end
            end

            private
            def order_params
                params.permit(:reference, :purchase_channel, :client_name, :adress, :delivery_service, :total_value, :line_items)
            end

        end
    end    
end
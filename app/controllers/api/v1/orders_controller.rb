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
            #before_action :authorize_request, except: :create
            # While authetication process is not implemented
            # skip_before_action :verify_authenticity_token
            before_action :authenticate_user!, except: [:index, :show]
            def index
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
                    if params[:report] == 'yes'
                        @orders_by_channel =  Order.distinct(:purchase_channel).group(:purchase_channel).count
                        @total_value_by_channel =  Order.distinct(:purchase_channel).group(:purchase_channel).sum(:total_value)
                        render json: {status: 'SUCCESS', message:'Finnacial Report', orders_by_channel:@orders_by_channel, total_value_by_channel:@total_value_by_channel }
                    elsif params[:test] == 'yes'
                        @orders = Order.order('created_at DESC')
                        render json: {status: 'SUCCESS', message:'List of orders', data:@orders}
                    else
                        @orders = Order.order('created_at DESC')                        
                    end
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
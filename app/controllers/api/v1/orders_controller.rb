module Api
    module V1
        class OrdersController < ApplicationController
            def index
                orders = Order.order('created_at DESC')
                render json: {status: 'SUCCESS', message:'List of orders.', data:orders}
            end
        end
    end    
end
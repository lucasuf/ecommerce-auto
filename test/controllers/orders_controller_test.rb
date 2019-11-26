require 'test_helper'
require_relative '../helpers/authorization_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include AuthorizationHelper
  setup do
    @order = orders(:one)
    test_user = { email: 'user@test.com', password: 'testuser' }
    sign_up(test_user)
    @auth_tokens = auth_tokens_for_user(test_user)
  end

  test "should get index" do
    get orders_url(test: 'yes'), as: :json
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, headers: @auth_tokens, params: orders(:one), as: :json
    end

    assert_response 200
  end

  test "should show order" do
    get order_url(@order),
    headers: @auth_tokens, as: :json
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), headers: @auth_tokens, params: { order: {  } }, as: :json
    assert_response 200
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order), headers: @auth_tokens, as: :json
    end

    assert_response 200
  end
end

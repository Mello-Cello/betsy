class OrdersController < ApplicationController
  def view_cart
    @order = Order.find_by(id: session[:cart_id])
  end
end

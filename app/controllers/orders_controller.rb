class OrdersController < ApplicationController
  before_action :find_cart_order

  def view_cart
  end

  def checkout
    unless @order
      flash[:error] = "Unable to checkout cart"
      redirect_to cart_path
    end
  end

  def purchase
    unless @order
      flash[:error] = "Unable to checkout cart"
      redirect_to cart_path
    end
  end

  private

  def find_cart_order
    @order = Order.find_by(id: session[:cart_id])
  end
end

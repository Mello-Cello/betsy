class OrdersController < ApplicationController
  def view_cart
    @order = Order.find_by(id: session[:cart_id])
  end

  def checkout
    @order = Order.find_by(id: session[:cart_id])
    unless @order
      flash[:error] = "Unable to checkout cart"
      redirect_to cart_path
    end
  end

  def purchase
  end
end

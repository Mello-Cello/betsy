class ApplicationController < ActionController::Base
  private

  def find_cart_order
    @order = Order.find_by(id: session[:cart_id])
  end
end

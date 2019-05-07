class ApplicationController < ActionController::Base
  private

  def find_logged_in_merchant
    if session[:merchant_id] #if session[:merchant_id] is not nil
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

  def find_cart_order
    @order = Order.find_by(id: session[:cart_id])
  end
end

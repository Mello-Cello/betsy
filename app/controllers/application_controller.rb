class ApplicationController < ActionController::Base
  private

<<<<<<< HEAD
  def find_merchant
    if session[:merchant_id] #if session[:merchant_id] is not nil
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
=======
  def find_cart_order
    @order = Order.find_by(id: session[:cart_id])
>>>>>>> 7c48a2719f675cf2023e119725bcff8e3f2771eb
  end
end

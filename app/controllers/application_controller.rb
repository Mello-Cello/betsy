class ApplicationController < ActionController::Base
  private

  def find_merchant
    if session[:merchant_id] #if session[:merchant_id] is not nil
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end
end

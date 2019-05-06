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
    if @order
      @order.update(order_params)
      if @order.valid?
        @order.status = complete
      end
    else
      flash[:error] = "Unable to checkout cart"
      redirect_to cart_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:shopper_name, :shopper_email, :shopper_address, :cc_four, :cc_exp)
  end
end

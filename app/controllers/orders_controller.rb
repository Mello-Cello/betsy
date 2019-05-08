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
    if @order && @order.update(order_params) && @order.cart_errors.empty?
      @order.cart_checkout
      @order.update(status: "paid", cc_four: params[:order][:cc_all][-4..-1]) # front end valid. on form for min 4 chars
      session[:cart_id] = nil
      flash[:success] = "Purchase Successful"
      redirect_to cart_path # temp will change to confirmation page.
    else
      flash[:error] = "Unable to checkout cart"
      if @order.cart_errors.any?
        cart_errors = []
        @order.cart_errors.each do |item|
          cart_errors << "#{item.product.name} available stock is #{item.product.stock}."
        end
        flash["Item exceeds available stock:"] = cart_errors
      end
      redirect_to cart_path
    end
  end

  private

  # only partial params, update if more attributes are required.
  def order_params
    params.require(:order).permit(:shopper_name, :shopper_email, :shopper_address, :cc_exp)
  end
end

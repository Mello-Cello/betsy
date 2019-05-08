class OrdersController < ApplicationController
  before_action :find_cart_order, except: [:show, :index]
  before_action :find_logged_in_merchant, only: [:show]

  def show
    if @login_merchant
      @order = Order.find_by(id: params[:id])
      if !@order || !@order.items.any? { |item| item.product.merchant_id == @login_merchant.id }
        flash[:error] = "Can not view order page. No items sold by merchant."
        redirect_to current_merchant_path
      end
    else
      flash[:error] = "You must be logged to view this page"
      redirect_to root_path
    end
  end

  def view_cart
  end

  def confirmation
    @order = Order.find_by(id: params[:id])
    if !@order || session[:confirmation] != @order.id
      flash[:error] = "Checkout cart to view confirmation page"
      redirect_to root_path
    else
      session[:confirmation] = nil
    end
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
      session[:confirmation] = session[:cart_id]
      session[:cart_id] = nil
      flash[:success] = "Purchase Successful"
      redirect_to order_confirmation_path(@order.id)
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

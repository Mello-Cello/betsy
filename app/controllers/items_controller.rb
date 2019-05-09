class ItemsController < ApplicationController
  before_action :find_cart_order, only: [:create]

  def create
    # find product and order
    @product = Product.find_by(id: params[:product_id])
    # if no current cart, create order and save to session.
    unless @order
      @order = Order.create
      session[:cart_id] = @order.id
    end
    # finds item in cart if already present and increments quantity (required for easy checkout)
    item = @order.items.find_by(product_id: @product.id) if @product
    if item
      item.quantity += params[:item][:quantity].to_i
    else
      item = Item.new(item_params)
    end

    if !@product
      flash.now[:error] = "Could Not Add To Cart: product not available"
      redirect_to products_path

      # check if requested quanitity is available
    elsif item.quantity && @product.stock < item.quantity
      flash.now[:error] = "Could Not Add To Cart: quantity selected is more than available stock"
      render "products/show", status: :bad_request
    else

      # set up relationships for item
      @product.items << item
      @order.items << item

      if item.valid?
        flash[:success] = "#{@product.name} (quantity: #{item.quantity}) Successfully Added To Cart"
        redirect_to product_path(@product.id)
      else
        flash.now[:error] = "Could Not Add To Cart"
        item.errors.messages.each do |label, message|
          flash.now[label.to_sym] = message
        end
        render "products/show", status: :bad_request
      end
    end
  end

  def update
    raise
  end

  def destroy
    item = Item.find_by(id: params[:id])
    if item
      flash[:success] = "#{item.product.name} successfully removed from cart"
      item.destroy
      redirect_to cart_path
    else
      flash[:error] = "Unable to remove item"
      redirect_to cart_path
    end
  end

  private

  def item_params
    return params.require(:item).permit(:quantity)
  end
end

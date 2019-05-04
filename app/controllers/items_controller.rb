class ItemsController < ApplicationController
  def create
    # find product and order
    @product = Product.find_by(id: params[:product_id])
    order = Order.find_by(id: session[:cart_id])
    # if no current cart, create order and save to session.
    unless order
      order = Order.create
      session[:cart_id] = order.id
    end

    item = order.items.find_by(product_id: @product.id)
    if item
      item.quantity += params[:item][:quantity]
    else
      item = Item.new(item_params)
    end

    # check if requested quanitity is available
    if @product.stock < item.quantity
      flash.now[:error] = "Could Not Add To Cart: quantity selected is more than available stock"
      render "products/show", status: :bad_request
    else

      # set up relationships for item
      @product.items << item
      order.items << item

      if item.valid?
        flash[:success] = "#{@product.name} Successfully Added To Cart"
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
  end

  def delete
  end

  private

  def item_params
    return params.require(:item).permit(:quantity)
  end
end

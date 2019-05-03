class ItemsController < ApplicationController
  def create
    @product = Product.find_by(id: params[:product_id])
    item = Item.new(item_params)
    if @product.stock <= item.quantity
      flash.now[:error] = "Could Not Add To Cart: quantity selected is more than available stock"
      render "product/show", status: :bad_request
    end
    @product.items << item
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

  def update
  end

  def delete
  end

  private

  def item_params
    return params.require(:item).permit(:quantity)
  end
end

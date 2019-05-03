class ItemsController < ApplicationController
  def create
    @product = Product.find_by(id: params[:product_id])
    item = Item.new(item_params)
    if @product.stock <= item.quantity
      render "product/show", status: :bad_request
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

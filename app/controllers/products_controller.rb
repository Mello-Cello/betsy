class ProductsController < ApplicationController
  def new
  end

  def create
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
    end
  end

  def edit
  end

  def update
  end
end

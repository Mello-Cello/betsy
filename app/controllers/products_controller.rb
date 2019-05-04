class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    product = Product.new(product_params)

    is_successful = product.save

    if is_successful
      flash[:success] = "Product added successfully"
      redirect_to product_path(product.id)
    else
      flash.now[:error] = "Could not add new product: #{product.errors.messages}" #need help formatting this flash better
    end
    render :new, status: :bad_request
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:error] = "Unknown product"
      redirect_to products_path
    end
  end

  def edit
  end

  def update
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :photo_url, :stock, :merchant_id, category_ids: [])
  end
end

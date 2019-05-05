class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    find_merchant
    if @login_merchant # if merchant is logged in
      product = Product.new(product_params)

      is_successful = product.save

      if is_successful
        flash[:success] = "Product added successfully"
        redirect_to product_path(product.id)
      else
        flash.now[:error] = "Could not add new product: #{product.errors.messages}" #need help formatting this flash better
        render :new, status: :bad_request
      end
    else
      flash.now[:error] = "You must be logged in to create a new product"
      render :new, status: :bad_request
    end
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

class ProductsController < ApplicationController
  before_action :find_merchant, only: [:new, :create]

  def new
    if @login_merchant
      @product = Product.new(photo_url: "http://placekitten.com/200/300")
    else
      flash[:error] = "You must be logged in to add a new product"
      redirect_to root_path
    end
  end

  def create
    if @login_merchant # if merchant is logged in
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id]
      @product.price = params[:product][:price].to_f * 100.0
      is_successful = @product.save

      if is_successful
        flash[:success] = "Product added successfully"
        redirect_to product_path(@product.id)
      else
        flash.now[:error] = "Could not add new product:"
        @product.errors.messages.each do |label, message|
          flash.now[label.to_sym] = message
        end
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
    if @login_merchant
      @product = Product.find_by(id: params[:id])
      @product.price = @product.price.to_f / 100.0

      if @product.nil?
        flash[:error] = "Unknown product"
        redirect_to products_path
      end
    else
      flash[:error] = "You must be logged in to edit product"
      redirect_to root_path
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    @product.update(product_params)
    @product.price = product_params[:price].to_f * 100.0
    @product.save

    if @product.valid?
      flash[:success] = "Product updated successfully"
      redirect_to product_path(@product.id)
    else
      @product.errors.messages.each do |label, message|
        flash.now[label.to_sym] = message
      end
      render :edit, status: :bad_request
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :photo_url, :stock, :merchant_id, category_ids: [])
  end
end

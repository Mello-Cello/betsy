class ProductsController < ApplicationController
  before_action :find_logged_in_merchant, except: [:index, :show]
  before_action :find_product, except: [:new, :create, :index]

  def new
    if @login_merchant
      @product = Product.new(photo_url: "http://placekitten.com/200/300")
    else
      flash[:error] = "You must be logged in to add a new product"
      redirect_to root_path
    end
  end

  def create
    if @login_merchant
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id]
      @product.save

      if @product.valid?
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
    if @product.nil? || !@product.active
      flash[:error] = "Unknown product"
      redirect_to products_path
    end
  end

  def edit
    if @login_merchant
      if @product.nil? || !@product.active
        flash[:error] = "Unknown product"
        redirect_to products_path
      end
    else
      flash[:error] = "You must be logged in to edit a product"
      redirect_to products_path
    end
  end

  def update
    if @product.merchant_id == @login_merchant.id
      @product.update(product_params)

      if @product.valid?
        flash[:success] = "Product updated successfully"
        redirect_to product_path(@product.id)
      else
        @product.errors.messages.each do |label, message|
          flash.now[label.to_sym] = message
        end
        render :edit, status: :bad_request
      end
    else
      flash[:error] = "You can only update your own products"
      redirect_to products_path
    end
  end

  def toggle_inactive
    if @login_merchant && @product.valid?
      if @product.merchant_id == @login_merchant.id
        @product.toggle(:active)
        # raise
        is_successful = @product.save

        if is_successful
          flash[:success] = "Product status changed successfully"
        else
          flash[:error] = "Product status not changed successfully"
        end
      else
        flash[:error] = "You may only change the status of your own products"
      end
    else
      flash[:error] = "You must be logged in to change the status of a product"
    end
    redirect_to current_merchant_path
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    if params[:product][:price]
      params[:product][:price] = params[:product][:price].to_f * 100.0
    end
    return params.require(:product).permit(:name, :price, :description, :photo_url, :stock, :merchant_id, category_ids: [])
  end
end

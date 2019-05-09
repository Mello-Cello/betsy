class CategoriesController < ApplicationController
  before_action :find_logged_in_merchant, only: [:new, :create]

  def new
    if @login_merchant
      @category = Category.new
    else
      flash[:error] = "You must be logged in to add a new category"
      redirect_to root_path
    end
  end

  def create
    if @login_merchant
      @category = Category.new(category_params)
      is_successful = @category.save

      if is_successful
        flash[:success] = "Category added successfully"
        redirect_to categories_path
      else
        flash.now[:error] = "Could not add new category:"
        @category.errors.messages.each do |label, message|
          flash.now[label.to_sym] = message
        end
        render :new, status: :bad_request
      end
    else
      flash.now[:error] = "You must be logged in to create a new category"
      render :new, status: :bad_request
    end
  end

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:error] = "Unknown category"
      redirect_to categories_path
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end

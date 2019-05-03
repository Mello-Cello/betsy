class CategoriesController < ApplicationController
  def new
  end

  def create
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
end

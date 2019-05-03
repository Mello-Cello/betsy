class ReviewsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    review = Review.new(review_params)
    @product.reviews << review
    if review.valid?
      flash[:success] = "Review Successfully Added"
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = "Could Not Add Review"
      review.errors.messages.each do |label, message|
        flash.now[label.to_sym] = message
      end
      render "products/show", status: :bad_request
    end
  end

  private

  def review_params
    return params.require(:review).permit(:comment, :rating)
  end
end

require "test_helper"

describe ReviewsController do
  describe "create" do
    describe "not logged in user" do
      it "will create a new review" do
        review_param = { review: { rating: 3,
                                   comment: "wow so great" } }
        product = products(:product_1)

        expect {
          post product_reviews_path(product), params: review_param
        }.must_change "Review.count", 1

        expect(flash[:success]).must_equal "Review Successfully Added"

        must_respond_with :redirect
        must_redirect_to product_path(product)
      end

      it "will not create a reiew if params are invalid" do
        review_param = { review: { rating: 8,
                                   comment: "wow so great" } }
        product = products(:product_1)

        expect {
          post product_reviews_path(product), params: review_param
        }.must_change "Review.count", 0

        expect(flash[:error]).must_equal "Could Not Add Review"
        expect(flash[:rating]).must_equal ["is not included in the list"]

        must_respond_with :bad_request
      end
    end
    describe "as a merchant" do
      before do
        perform_login()
      end
      it "will create a new review of a product that does not belong to merchant" do
        review_param = { review: { rating: 3,
                                   comment: "wow so great" } }
        product = products(:product_1)

        expect {
          post product_reviews_path(product), params: review_param
        }.must_change "Review.count", 1

        expect(flash[:success]).must_equal "Review Successfully Added"

        must_respond_with :redirect
        must_redirect_to product_path(product)
      end

      it "a merchant cannot create a review their own product" do
        review_param = { review: { rating: 3,
                                   comment: "wow so great" } }
        product = products(:product_3)
        expect {
          post product_reviews_path(product), params: review_param
        }.must_change "Review.count", 0

        expect(flash[:error]).must_equal "Merchants cannot review their own product."
   
        must_respond_with :bad_request
      end
    end
  end
end

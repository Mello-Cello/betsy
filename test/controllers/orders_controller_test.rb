require "test_helper"

describe OrdersController do
  describe "view_cart" do
    it "will respond with success if no cart is stored in session" do
      get cart_path
      must_respond_with :success
      expect(session[:cart_id]).must_be_nil
    end

    let(:product) { products(:product_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will respond with success if cart stored in session" do
      post product_items_path(product.id), params: item_params
      get cart_path
      must_respond_with :success
      expect(session[:cart_id]).wont_be_nil
    end
  end

  describe "checkout" do
    let(:product) { products(:product_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will respond with success if cart stored in session" do
      post product_items_path(product.id), params: item_params
      get checkout_cart_path
      must_respond_with :success
      expect(session[:cart_id]).wont_be_nil
    end

    it "will redirect if no valid cart in session" do
      get checkout_cart_path
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:error]).must_equal "Unable to checkout cart"
      expect(session[:cart_id]).must_be_nil
    end
  end
end

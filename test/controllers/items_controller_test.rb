require "test_helper"

describe ItemsController do
  describe "create" do
    let(:product) { products(:product_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will create a new item" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 1

      expect(flash[:success]).must_equal "#{product.name} Successfully Added To Cart"

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "will create a new order if no order in session" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 1

      expect(flash[:success]).must_equal "#{product.name} Successfully Added To Cart"

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "will use current order if cart_id in session " do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 1

      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 0

      expect(flash[:success]).must_equal "#{product.name} Successfully Added To Cart"

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "will not create a new item if product is not valid" do
      product_id = -1
      expect {
        post product_items_path(product_id), params: item_params
      }.must_change "Item.count", 0

      expect(flash[:error]).must_equal "Could Not Add To Cart: product not available"

      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "will not create an item for with requested quantitiy greater tthan the products stock" do
      item_params[:item][:quantity] = product.stock + 1
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 0

      expect(flash[:error]).must_equal "Could Not Add To Cart: quantity selected is more than available stock"

      must_respond_with :bad_request
    end

    it "will not create an item with in invalid quantity" do
      item_params[:item][:quantity] = nil
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 0

      expect(flash[:error]).must_equal "Could Not Add To Cart"

      must_respond_with :bad_request
    end
  end
end

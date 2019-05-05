require "test_helper"

describe ItemsController do
  describe "create" do
    let(:product) { products(:product_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will create a new item" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 1
    end

    it "will create a new order if no order in session" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 1
    end

    it "will use current order if cart_id in session " do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 1
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 0
    end

    it "will not create a new item if product is not valid" do
    end

    it "will not create an item for with requested quantitiy greater tthan the products stock" do
    end
  end
end

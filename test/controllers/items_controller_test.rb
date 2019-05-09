require "test_helper"

describe ItemsController do
  describe "create" do
    let(:product) { products(:product_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will create a new item" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 1

      expect(flash[:success]).must_equal "#{product.name} (quantity: #{item_params[:item][:quantity]}) Successfully Added To Cart"

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "will create a new order if no order in session" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 1

      expect(flash[:success]).must_equal "#{product.name} (quantity: #{item_params[:item][:quantity]}) Successfully Added To Cart"

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "will use current order if cart_id in session " do
      expect {
        post product_items_path(products(:product_2)), params: item_params
      }.must_change "Order.count", 1

      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Order.count", 0

      expect(flash[:success]).must_equal "#{product.name} (quantity: #{item_params[:item][:quantity]}) Successfully Added To Cart"

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

    it "will not create an item for with requested quantitiy greater than the products stock" do
      item_params[:item][:quantity] = product.stock + 1
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 0

      expect(flash[:error]).must_equal "Could Not Add To Cart: quantity selected is more than available stock"

      must_respond_with :bad_request
    end

    it "will find an item if already created and increase its quantity rather than make new" do
      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 1

      item = Item.find_by(product_id: product.id, order_id: session[:cart_id])
      expect(item.quantity).must_equal item_params[:item][:quantity]

      expect {
        post product_items_path(product.id), params: item_params
      }.must_change "Item.count", 0

      item = Item.find_by(product_id: product.id, order_id: session[:cart_id])
      expect(item.quantity).must_equal item_params[:item][:quantity] * 2
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

  describe "update" do
    let(:item) { items(:item_1) }
    let(:item_params) { { item: { quantity: 2 } } }
    it "will update a valid item if product has enough stock" do
      expect {
        patch item_path(item.id), params: item_params
      }.wont_change "Item.count"
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:success]).must_equal "#{item.product.name} successfully updated"
    end

    it "will not update a product if update of quantity exceeds product stock" do
      products(:product_1).update(stock: 1)

      expect {
        patch item_path(item.id), params: item_params
      }.wont_change "Item.count"
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:error]).must_equal "Unable to update item"
    end

    it "will show flash message and redirect updated item is invalid" do
      item_params[:item][:quantity] = -1
      expect {
        patch item_path(item.id), params: item_params
      }.wont_change "Item.count"
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:error]).must_equal "Unable to update item"
    end

    it "will show flash message and redirect if item is not found " do
      invalid_id = -1
      expect {
        patch item_path(invalid_id), params: item_params
      }.wont_change "Item.count"
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:error]).must_equal "Unable to update item"
    end
  end

  describe "destroy" do
    let(:item) { items(:item_1) }
    it "will destroy a valid item" do
      expect {
        delete item_path(item.id)
      }.must_change "Item.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "will not destroy an item given invalid id" do
      invalid_id = -1
      expect {
        delete item_path(invalid_id)
      }.must_change "Item.count", 0

      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end
end

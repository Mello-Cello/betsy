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

  describe "purchase" do
    let(:product) { products(:product_1) }
    let(:product2) { products(:product_2) }
    let(:item_params) { { item: { quantity: 2 } } }
    let(:cart_params) {
      { order: { shopper_name: "susie",
                 shopper_email: "dalmation@susy.org",
                 shopper_address: "4455 mailing address",
                 cc_all: "234443434",
                 cc_exp: "03022020" } }
    }
    before do
      post product_items_path(product.id), params: item_params
      post product_items_path(product2.id), params: item_params
    end
    it "will set cart in srssion to nil if valid cart purchase" do
      expect(session[:cart_id]).wont_be_nil

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"

      expect(session[:cart_id]).must_be_nil
    end

    it "will change order status from pending to complete if valid cart purchase" do
      order = Order.find_by(id: session[:cart_id])
      expect(order.status).must_equal "pending"

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"
      order.reload
      expect(order.status).must_equal "complete"
    end

    it "will change product stock by amount bought if valid cart purchase " do
      product_stock = product.stock + product2.stock

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"
      product.reload
      product2.reload
      expect(product_stock - 4).must_equal product.stock + product2.stock
    end

    it "will have flash message and redirect to correct page if valid cart purchase" do
      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"

      expect(flash[:success]).must_equal "Purchase Successful"
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    describe "checking out will an invalid cart" do
      let(:product) { products(:product_1) }
      let(:product2) { products(:product_2) }
      let(:item_params) { { item: { quantity: 2 } } }
      let(:cart_params) {
        { order: { shopper_name: "susie",
                   shopper_email: "dalmation@susy.org",
                   shopper_address: "4455 mailing address",
                   cc_all: "234443434",
                   cc_exp: "03022020" } }
      }
      before do
        product.update(stock: 1)
        post product_items_path(product.id), params: item_params
        post product_items_path(product2.id), params: item_params
      end

      it "will have flash message and redirect to correct page if invalid cart purchase" do
        expect {
          post purchase_cart_path, params: cart_params
        }.wont_change "Order.count"

        expect(flash[:error]).must_equal "Unable to checkout cart"
        expect(flash["Item exceeds available stock:"]).must_equal ["bucket of rain available stock is 1."]
        must_respond_with :redirect
        must_redirect_to cart_path
      end

      it "will not change order status if invalid cart" do
        order = Order.find_by(id: session[:cart_id])
        expect(order.status).must_equal "pending"

        expect {
          post purchase_cart_path, params: cart_params
        }.wont_change "Order.count"

        expect(order.status).must_equal "pending"
      end

      it "will not change product stock if invalid cart" do
        product_stock = product.stock + product2.stock

        expect {
          post purchase_cart_path, params: cart_params
        }.wont_change "Order.count"

        product.reload
        product2.reload
        expect(product_stock).must_equal product.stock + product2.stock
      end

      it "will not change cart in session if invalid cart" do
        expect(session[:cart_id]).wont_be_nil
        expect {
          post purchase_cart_path, params: cart_params
        }.wont_change "Order.count"
        expect(session[:cart_id]).wont_be_nil
      end
    end
  end
end

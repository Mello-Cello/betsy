require "test_helper"

describe OrdersController do
  # removed index path and controller rather than using it just to redirect
  # describe "index" do
  #   it "will redirect all calls to home page" do
  #     get orders_path
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end
  # end
  describe "show" do
    describe "not logged in" do
      it "will redirct to root path with flash message" do
      end
    end

    describe "as a logged in merchant" do
      it "will show order page if merchant has a product in the order" do
      end

      it "will redirect to merchant dashboard if no products for order belong to mechant" do
      end
    end
  end
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

  describe "confirmation" do
    let(:product) { products(:product_1) }
    let(:product2) { products(:product_2) }
    let(:item_params) { { item: { quantity: 2 } } }
    let(:cart_params) {
      { order: { shopper_name: "susie",
                 shopper_email: "dalmation@susy.org",
                 shopper_address: "44550 mailing address",
                 cc_all: "234443434",
                 cc_exp: "03022020" } }
    }
    before do
      post product_items_path(product.id), params: item_params
      post product_items_path(product2.id), params: item_params
      @order = Order.find(session[:cart_id])
    end
    describe "following succesful purchase of cart" do
      before do
        post purchase_cart_path, params: cart_params
      end
      it "will respond with success" do
        get order_confirmation_path(@order.id)
        must_respond_with :success
      end

      it "will reset confirmation in session to nil" do
        expect(session[:confirmation]).must_equal @order.id
        get order_confirmation_path(@order.id)
        expect(session[:confirmation]).must_be_nil
      end
    end

    describe "not following purchase of cart" do
      it "will redirect to root and not make changes to session[:confirmation]" do
        expect(session[:confirmation]).must_be_nil

        get order_confirmation_path(@order.id)

        expect(session[:confirmation]).must_be_nil
        expect(flash[:error]).must_equal "Checkout cart to view confirmation page"
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
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
                 shopper_address: "44550 mailing address",
                 cc_all: "234443434",
                 cc_exp: "03022020" } }
    }
    before do
      post product_items_path(product.id), params: item_params
      post product_items_path(product2.id), params: item_params
    end
    it "will set cart in session to nil if valid cart purchase" do
      expect(session[:cart_id]).wont_be_nil

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"

      expect(session[:cart_id]).must_be_nil
    end

    it "will set confirmation to true in session if valid cart purchase" do
      expect(session[:confirmation]).must_be_nil
      order_id = session[:cart_id]

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"

      expect(session[:confirmation]).must_equal order_id
    end

    it "will change order status from pending to paid if valid cart purchase" do
      order = Order.find_by(id: session[:cart_id])
      expect(order.status).must_equal "pending"

      expect {
        post purchase_cart_path, params: cart_params
      }.wont_change "Order.count"
      order.reload
      expect(order.status).must_equal "paid"
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

      order = Order.find_by(shopper_address: "44550 mailing address")
      expect(flash[:success]).must_equal "Purchase Successful"
      must_respond_with :redirect
      must_redirect_to order_confirmation_path(order)
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

      it "will set not set confirmation in session if invalid cart purchase attempt" do
        expect(session[:confirmation]).must_be_nil

        expect {
          post purchase_cart_path, params: cart_params
        }.wont_change "Order.count"

        expect(session[:confirmation]).must_be_nil
      end
    end
  end
end

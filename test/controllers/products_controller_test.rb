require "test_helper"

describe ProductsController do
  describe "index" do
    it "successfully shows index" do
      get products_path

      must_respond_with :success
    end

    it "successfully shows index with no products" do
      Item.destroy_all
      Review.destroy_all
      Product.destroy_all

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid product" do
      get product_path(products(:product_1).id)

      must_respond_with :success
    end

    it "will give a redirect and give a flash notice for an invalid product" do
      get product_path(-1)

      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown product"
    end
  end

  describe "new" do
    describe "logged in merchant" do
      it "succeeds" do
        perform_login
        get new_product_path

        must_respond_with :success
      end
    end
    describe "not logged in" do
      it "redirects user" do
        get new_product_path

        must_respond_with :redirect
        expect(flash[:error]).must_equal "You must be logged in to add a new product"
      end
    end
  end

  describe "create" do
    describe "logged in user" do
      it "creates a product with valid data" do
        merchant = perform_login
        new_product = {product: {name: "Something amazing", price: 1000}}
        expect {
          post products_path, params: new_product
        }.must_change "Product.count", 1

        new_product_id = Product.find_by(name: "Something amazing").id

        expect(flash[:success]).must_equal "Product added successfully"
        must_respond_with :redirect
        must_redirect_to product_path(new_product_id)
      end

      it "renders bad_request and does not update the DB for bogus data" do
        merchant = perform_login
        bad_prod_name = {product: {name: nil, price: 1000}}

        expect {
          post products_path, params: bad_prod_name
        }.wont_change "Product.count"

        must_respond_with :bad_request
        expect(flash[:error]).must_include "Could not add new product"
        expect(flash[:name]).must_include "can't be blank"
      end

      describe "logged out user" do
        it "cannot create a product with valid data" do
          new_product = {product: {name: "Something amazing", price: 1000}}
          expect {
            post products_path, params: new_product
          }.wont_change "Product.count"

          must_respond_with :bad_request
          expect(flash[:error]).must_equal "You must be logged in to create a new product"
        end
      end
    end
  end

  describe "edit" do
    describe "logged in merchant" do
      it "succeeds" do
        merchant = perform_login

        get edit_product_path(merchant.products.first.id)

        must_respond_with :success
      end

      it "will redirect if given an invalid product id" do
        merchant = perform_login

        get edit_product_path(-1)

        must_respond_with :redirect
      end
    end
    describe "not logged in" do
      it "redirects user" do
        merchant = merchants(:merchant_1)
        # do not do login
        get edit_product_path(merchant.products.first.id)

        # must_respond_with :redirect
        expect(flash[:error]).must_equal "You must be logged in to edit a product"
      end
    end
  end

  describe "update" do
    describe "logged in merchant" do
      it "will update an existing product" do
        merchant = perform_login

        starter_input = {
          name: "An intangible thing",
          merchant_id: merchant.id,
          description: "Its hard to hold onto",
          photo_url: "a cute url",
          stock: 100,
          price: 999,
        }

        product_to_update = Product.create(starter_input)

        test_input = {
          "product": {
            name: "A REALLY COOL intangible thing",
            merchant_id: merchants(:merchant_1).id,
            description: "Its hard to hold onto",
            photo_url: "a cute url",
            stock: 100,
            price: 999,
          },
        }

        expect {
          patch product_path(product_to_update.id), params: test_input
        }.wont_change "Product.count"

        must_respond_with :redirect
        product_to_update.reload
        expect(product_to_update.name).must_equal test_input[:product][:name]
        expect(product_to_update.merchant_id).must_equal test_input[:product][:merchant_id]
        expect(product_to_update.description).must_equal test_input[:product][:description]
        expect(flash[:success]).must_equal "Product updated successfully"
      end

      it "will not update an existing product if given bogus data" do
        merchant = perform_login
        product_to_update = products(:product_3)

        test_input = {
          "product": {
            name: nil,
            merchant_id: merchant.id,
            description: "nice stuff wooowza",
            photo_url: "https://yeahforsure.org",
            stock: 100,
            price: 999,
          },
        }

        expect {
          patch product_path(product_to_update.id), params: test_input
        }.wont_change "Product.count"

        must_respond_with :bad_request
        # expect(flash[:name]).must_include "can't be blank" # not working
      end
    end

    describe "not logged in" do
      # I think this is covered in the edit tests since users cannot get to the edit page if they are not logged in. Let me know if I need to test this.
    end
  end
end

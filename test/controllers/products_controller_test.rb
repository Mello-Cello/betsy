require "test_helper"

describe ProductsController do
  describe "index" do
    it "successfully shows index" do
      # Act
      get products_path

      # Assert
      must_respond_with :success
    end

    it "successfully shows index with no products" do
      # Product.all do |product|
      #   product.destroy
      # end
      Item.destroy_all
      Review.destroy_all
      Product.destroy_all

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid product" do

      # Act
      get product_path(products(:product_1).id)

      # Assert
      must_respond_with :success
    end

    it "will give a redirect and give a flash notice for an invalid product" do

      # Act
      get product_path(-1)

      # Assert
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
          # is setting merchant id to nil enough to test this?
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

        must_respond_with :found
      end

      it "will redirect if given an invalid product id" do
        merchant = perform_login

        get edit_product_path(-1)

        must_respond_with :redirect
      end
    end
    describe "not logged in" do
      it "redirects user" do
        merchant = perform_login

        delete logout_path

        get edit_product_path(merchant.products.first.id)

        must_respond_with :redirect
        expect(flash[:error]).must_equal "You must be logged in to edit a product"
      end
    end
  end

  describe "update" do
    describe "logged in merchant" do
      it "will update an existing product" do
      end

      it "will not update an existing product if given bogus data" do
      end
    end

    describe "not logged in" do
      # do I even need to test this since they can't get to this page?
    end
  end
end

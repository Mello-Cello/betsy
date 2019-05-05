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
      Product.all do |product|
        product.destroy
      end

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
    it "succeeds" do
      get new_product_path

      must_respond_with :success
    end
  end

  describe "create" do
    describe "logged in user" do
      it "creates a product with valid data" do
        merchant = perform_login
        new_product = {product: {name: "Something amazing", merchant_id: merchant.id, price: 1000}}
        expect {
          post products_path, params: new_product
        }.must_change "Product.count", 1

        new_product_id = Product.find_by(name: "Something amazing").id

        must_respond_with :redirect
        must_redirect_to product_path(new_product_id)
      end
    end

    it "renders bad_request and does not update the DB for bogus data" do
      merchant = perform_login
      bad_prod_name = {product: {name: nil, merchant_id: merchant.id, price: 1000}}
      bad_merch_id = {product: {name: "Awesome product", merchant_id: nil, price: 1000}}
      bad_price = {product: {name: "Awesomer product", merchant_id: merchant.id, price: 0}}

      expect {
        post products_path, params: bad_prod_name
      }.wont_change "Product.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_include "Could not add new product"
      expect(flash[:error]).must_include "name"
      expect(flash[:error]).must_include "can't be blank"

      expect {
        post products_path, params: bad_merch_id
      }.wont_change "Product.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_include "Could not add new product"
      expect(flash[:error]).must_include "merchant"
      expect(flash[:error]).must_include "must exist"

      expect {
        post products_path, params: bad_price
      }.wont_change "Product.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_include "Could not add new product"
      expect(flash[:error]).must_include "must be greater than 0"
    end
  end

  describe "logged out user" do
    it "cannot create a product with valid data" do
      # is setting merchant id to nil enough to test this?
      new_product = {product: {name: "Something amazing", merchant_id: nil, price: 1000}}
      expect {
        post products_path, params: new_product
      }.wont_change "Product.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_equal "You must be logged in to create a new product"
    end
  end
end

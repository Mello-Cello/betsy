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
        merchant = merchants(:merchant_1)
        new_product = {product: {name: "Something amazing", merchant_id: merchant.id, price: 1000}}
        expect {
          post products_path, params: new_product
        }.must_change "Product.count", 1

        # new_product_id = Product.find_by(name: "Something amazing").id

        # must_respond_with :redirect
        # must_redirect_to work_path(new_work_id)
      end
    end

    # it "renders bad_request and does not update the DB for bogus data" do
    #   bad_work = {work: {title: nil, category: "book"}}

    #   expect {
    #     post works_path, params: bad_work
    #   }.wont_change "Work.count"

    #   must_respond_with :bad_request
    # end

    # it "renders 400 bad_request for bogus categories" do
    #   INVALID_CATEGORIES.each do |category|
    #     invalid_work = {work: {title: "Invalid Work", category: category}}

    #     proc { post works_path, params: invalid_work }.wont_change "Work.count"

    #     Work.find_by(title: "Invalid Work", category: category).must_be_nil
    #     must_respond_with :bad_request
    #   end
    # end
  end
end

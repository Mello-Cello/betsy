require "test_helper"

describe ProductsController do
  describe "index" do
    it "should get index" do
      # Act
      get products_path

      # Assert
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
end

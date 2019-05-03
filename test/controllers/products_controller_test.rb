require "test_helper"

describe ProductsController do
  # it "should get new" do
  #   get products_new_url
  #   value(response).must_be :success?
  # end

  # it "should get create" do
  #   get products_create_url
  #   value(response).must_be :success?
  # end

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

    it "will redirect for an invalid product" do

      # Act
      get product_path(-1)

      # Assert
      must_respond_with :redirect
    end

    it "will give a flash notice for an invalid product" do

      # Act
      get product_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown product"
    end
  end

  # it "should get edit" do
  #   get products_edit_url
  #   value(response).must_be :success?
  # end

  # it "should get update" do
  #   get products_update_url
  #   value(response).must_be :success?
  # end
end

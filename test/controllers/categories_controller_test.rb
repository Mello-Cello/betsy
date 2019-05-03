require "test_helper"

describe CategoriesController do
  describe "index" do
    it "should get index" do
      # Act
      get categories_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid category" do

      # Act
      get category_path(categories(:category_1).id)

      # Assert
      must_respond_with :success
    end

    it "will redirect and give a flash notice for an invalid product" do

      # Act
      get category_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown category"
    end
  end
end

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

    it "will redirect and give a flash notice for an invalid category" do

      # Act
      get category_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown category"
    end
  end

  describe "new" do
    describe "logged in merchant" do
      it "succeeds" do
        perform_login
        get new_category_path

        must_respond_with :success
      end
    end

    describe "logged out" do
      it "redirects and give flash notice" do
        get new_category_path

        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:error]).must_equal "You must be logged in to add a new category"
      end
    end
  end

  describe "create" do
    describe "logged in merchant" do
      it "creates a category with valid data" do
        perform_login
        new_category = {category: {name: "Magic feeling"}}
        expect {
          post categories_path, params: new_category
        }.must_change "Category.count", 1

        expect(flash[:success]).must_equal "Category added successfully"
        must_respond_with :redirect
        must_redirect_to categories_path
      end

      it "renders bad_request and does not update the DB for bogus data" do
        perform_login
        bad_category_name = {category: {name: nil}}

        expect {
          post categories_path, params: bad_category_name
        }.wont_change "Category.count"

        must_respond_with :bad_request
        expect(flash[:error]).must_include "Could not add new category"
        expect(flash[:name]).must_include "can't be blank"
      end
    end

    describe "logged out" do
      it "cannot create a category with valid data" do
        new_category = {category: {name: "Magic feeling"}}
        expect {
          post categories_path, params: new_category
        }.wont_change "Category.count"

        must_respond_with :bad_request
        expect(flash[:error]).must_equal "You must be logged in to create a new category"
      end
    end
  end
end

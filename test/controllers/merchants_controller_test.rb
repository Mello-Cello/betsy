require "test_helper"
require "pry"

describe MerchantsController do
  describe "index" do
    it "should get index" do
      # Act
      get merchants_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid merchant" do

      # Act
      get merchant_path(merchants(:merchant_1).id)

      # Assert
      must_respond_with :success
    end

    it "will redirect and give a flash notice for an invalid merchant" do

      # Act
      get merchant_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown merchant"
    end
  end

  describe "login" do
    it "log in an existing merchant" do
      start_count = Merchant.count
      merchant = merchants(:merchant_1)
      # binding.pry
      perform_login(merchant)
      session[:merchant_id].must_equal merchant.id

      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end

    it "create a new merchant if the user has not previously been saved in our database" do
      # Arrange
      start_count = Merchant.count

      # Act
      # new_merch = Merchant.create(new_merchant_params)
      new_merch = Merchant.new(provider: "github", uid: "443356", username: "ellesmom", email: "jackie@who.net")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merch))
      get auth_callback_path(:github)

      # Assert
      Merchant.count.must_equal start_count + 1
      must_respond_with :redirect

      expect(flash[:success]).must_equal "Logged in as new merchant #{new_merch.username}"

      must_redirect_to root_path
    end

    it "give an error if a new merchant fails to save after validation" do
      start_count = Merchant.count

      new_merch = Merchant.new(provider: "github", uid: "", username: "ellesmom", email: "jackie@who.net")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merch))
      get auth_callback_path(:github)

      # Assert
      Merchant.count.must_equal start_count

      expect(flash[:error]).must_equal "Could not create new merchant account: {:uid=>[\"can't be blank\"]}"

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "successfully log out a logged-in merchant" do
      # Arrange
      start_count = Merchant.count
      merchant = merchants(:merchant_1)
      # binding.pry
      perform_login

      # Act
      delete logout_path

      # Assert
      # check flash message
      expect(flash[:success]).must_equal "Successfully logged out."
      # check session id gets set to nil
      session[:merchant_id].must_be_nil
      # check redirect to root_path
      must_respond_with :redirect

      must_redirect_to root_path
      # Should *not* have created or deleted a user
      Merchant.count.must_equal start_count
    end
  end
end

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
    it "logs in an existing user" do
      start_count = Merchant.count
      merchant = merchants(:merchant_1)
      # binding.pry
      perform_login(merchant)
      session[:merchant_id].must_equal merchant.id

      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end
  end
end

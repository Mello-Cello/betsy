require "test_helper"

describe MerchantsController do
  # it "should get create" do
  #   get merchants_create_url
  #   value(response).must_be :success?
  # end

  # it "should get show" do
  #   get merchants_show_url
  #   value(response).must_be :success?
  # end

  # it "should get delete" do
  #   get merchants_delete_url
  #   value(response).must_be :success?
  # end

  it "logs in an existing user" do
    start_count = Merchant.count
    merchant = merchants(:merchant_1)

    perform_login(merchant)
    session[:merchant_id].must_equal merchant.id

    # Should *not* have created a new user
    Merchant.count.must_equal start_count
  end
end

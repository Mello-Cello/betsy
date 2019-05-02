require "test_helper"

describe MerchantsController do
  it "should get create" do
    get merchants_create_url
    value(response).must_be :success?
  end

  it "should get show" do
    get merchants_show_url
    value(response).must_be :success?
  end

  it "should get delete" do
    get merchants_delete_url
    value(response).must_be :success?
  end

end

require "test_helper"

describe ItemsController do
  it "should get create" do
    get items_create_url
    value(response).must_be :success?
  end

  it "should get update" do
    get items_update_url
    value(response).must_be :success?
  end

  it "should get delete" do
    get items_delete_url
    value(response).must_be :success?
  end

end

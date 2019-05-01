require "test_helper"

describe Merchant do
  let(:merchant){merchants(:one)}

  it "must be valid" do
    expect(merchant.valid?).must_equal true
  end
end

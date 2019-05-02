require "test_helper"

describe Item do
  let(:item) { items(:item_1) }

  it "must be valid" do
    expect(item.valid?).must_equal true
  end
end

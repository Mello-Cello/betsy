require "test_helper"

describe Product do
  let(:product) { products(:product_1) }

  it "must be valid" do
    value(product).must_be :valid?
  end
end

require "test_helper"

describe Order do
  let(:order) { orders(:order_1) }

  it "must be valid" do
    value(order).must_be :valid?
  end
end



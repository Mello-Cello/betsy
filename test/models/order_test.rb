require "test_helper"

describe Order do
  let(:order) { orders(:order_1) }

  it "must be valid" do
    expect(order.valid?).must_equal true
  end

# has_many :items
describe "relationship with an order" do
  it "can have 0 items" do
    Item.destroy_all
      expect(order.items.count).must_equal 0
  end

  it "can have 1 or more items" do
    expect(order.items.count).must_equal 2
  end
end
  
it "can shovel items to create a relationship" do
    product = products(:product_1)
    item = Item.new(quantity: 3, product: product)
    expect(item.valid?).must_equal false
    order.items << item
    expect(item.valid?).must_equal true
    expect(order.items.include?(item)).must_equal true
  end
end
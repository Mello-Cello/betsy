require "test_helper"

describe Order do
  let(:order) { orders(:order_1) }

  it "must be valid" do
    expect(order.valid?).must_equal true
  end

  describe "validations" do
    it "has a default value of 'pending'" do
      order = Order.new
      expect(order.status).must_equal "pending"
    end

    it "will be valid if given status of [\"pending\", \"paid\", \"complete\", \"cancelled\"]" do
      ["pending", "paid", "complete", "cancelled"].each do |status|
        order.update(status: status)
        expect(order.valid?).must_equal true
      end
    end

    it "will not be valid if status is different from above" do
      ["penddding", "paiad", "compledte", "cancnelled"].each do |status|
        order.update(status: status)
        expect(order.valid?).must_equal false
      end
    end

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
  describe "custom methods" do
    describe do
    end
    describe do
    end
    describe do
    end
  end
end

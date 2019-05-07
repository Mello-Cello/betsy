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
    describe "  def total" do
      it "will calculate total cost of cart" do
        total_cost = items(:item_1).quantity * items(:item_1).product.price / 100.0
        total_cost += items(:item_2).quantity * items(:item_2).product.price / 100.0
        expect(order.total).must_be_close_to total_cost
      end

      it "will return nil if invalid item in cart" do
        order.items << Item.new(order_id: order.id)
        expect(order.total).must_be_nil
      end

      it "will return nil if item has an invalid item in cart" do
        items(:item_3).product = Product.new
        order.items << items(:item_3)
        expect(order.total).must_be_nil
      end
    end
    describe "cart errors" do
      it "will return [] if all items are available for purchase" do
        expect(order.cart_errors).must_equal []
      end

      it "will return items in array that are not available for purchase" do
        items(:item_3).quantity = 1000
        order.items << items(:item_3)
        items(:item_1).update(quantity: 2000)
        expect(order.cart_errors.sort!).must_equal [items(:item_1), items(:item_3)].sort!
      end

      it "will return nil if item(s) are not valid" do
        order.items << Item.new(order_id: order.id)
        expect(order.cart_errors).must_be_nil
      end

      it "will return nil if an items product is not valid" do
        items(:item_3).product = Product.new
        order.items << items(:item_3)
        expect(order.cart_errors).must_be_nil
      end
    end
    describe " def cart_checkout" do
      # tests for quantity decrease/not decreasing
      # done in product model test, custom methods section.
      it "will return true if items and products are valid" do
        expect(order.cart_checkout).must_equal true
      end

      it "will return nil if item(s) are not valid" do
        order.items << Item.new(order_id: order.id)
        expect(order.cart_checkout).must_be_nil
      end
      it "will return nil if an items product is not valid" do
        items(:item_3).product = Product.new
        order.items << items(:item_3)
        expect(order.cart_checkout).must_be_nil
      end
    end
  end
end

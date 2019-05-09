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

    describe "class methods " do
      let(:merchant) { merchants(:merchant_2) }
      let(:item_hash) { Order.find_merchant_order_items(merchant) }
      describe "self.find_merchant_order_items(merchant, items_hash: {\"paid\" => {}, \"complete\" => {} })" do
        it "will return a nested hash structure thatsstores merchant order items:
        key is order status and value is a hash with order_id as key and array of item objects as value:" do
          expect(item_hash.to_s).must_equal ({ "paid" => { "615724322" => [Item.find(477087474)] }, "complete" => { "1035625630" => [Item.find(845260767), Item.find(728299111)] } }).to_s
        end

        it "will return empty hash for values with no orders in an order.status" do
          expect(Order.find_merchant_order_items(merchants(:merchant_3)).to_s).must_equal ({ "paid" => {}, "complete" => {} }).to_s
        end

        it "will return hash with additional statuses and add orders to them passed as params" do
          expect(Order.find_merchant_order_items(merchant, items_hash: { "paid" => {}, "complete" => {}, "pending" => {} }).to_s).must_equal ({ "paid" => { "615724322" => [Item.find(477087474)] }, "complete" => { "1035625630" => [Item.find(845260767), Item.find(728299111)] }, "pending" => { "330565047" => [Item.find(34296661)] } }).to_s
        end

        # NOT 100% SURE IF THESE TESTS ARE ACTUALLY TESTING WHAT THEY ARE SUPPOSED TO.
        # ALSO LOTS OF CHECKS AND VAILDATIONS, SO THESE SCENARIOS WOULD NOT HAPPEN. DO # THESE EVEN HAVE TO BE TESTED?

        # it "invalid order will not be added to hash" do
        #   order = Order.new(status: "noneya")
        #   item = Item.new(product: products(:product_2), order: order, quantity: 4)
        #   expect(item.valid?).must_equal true
        #   expect(order.valid?).must_equal false
        #   expect(item_hash.to_s).must_equal ({ "paid" => { "615724322" => [Item.find(477087474)] }, "complete" => { "1035625630" => [Item.find(845260767), Item.find(728299111)] } }).to_s
        # end

        # it "invalid item will not be added to hash" do
        #   items(:item_2).update(quantity: nil)
        #   expect(items(:item_2).valid?).must_equal false
        #   expect(item_hash.to_s).must_equal ({ "paid" => { "615724322" => [Item.find(477087474)] }, "complete" => { "1035625630" => [Item.find(845260767)] } }).to_s
        # end

        it "invalid order will not be added to hash even if supplied the status in item_hash" do
          order = Order.new(status: "noneya")
          item = Item.new(product: products(:product_2), order: order, quantity: 4)
          expect(item.valid?).must_equal true
          expect(order.valid?).must_equal false
          expect(Order.find_merchant_order_items(merchant, items_hash: { "paid" => {}, "complete" => {}, "noneya" => {} }).to_s).must_equal ({ "paid" => { "615724322" => [Item.find(477087474)] }, "complete" => { "1035625630" => [Item.find(845260767), Item.find(728299111)] }, "noneya" => {} }).to_s
        end
      end

      describe " def self.status_revenue(item_status)" do
        let(:revenue_completed) { Order.status_revenue(item_hash["complete"]) }

        it "will calculate the sum of all the orders of a given satus" do
          expect(revenue_completed).must_be_close_to Item.find(845260767).subtotal + Item.find(728299111).subtotal
        end

        it "will return 0 if no items for a given status" do
          Item.destroy_all
          expect(revenue_completed).must_equal 0
        end

        it "will return 0 if asked for revenue of status that is not in hash" do
          expect(Order.status_revenue(item_hash["not a real status"])).must_equal 0
        end
      end

      describe "def self.status_count_orders(item_status)" do
        it "will count all the orders of a given status " do
          orders(:order_2).update(status: "complete")
          expect(orders(:order_2).valid?).must_equal true

          expect(Order.status_count_orders(item_hash["complete"])).must_equal 2
        end

        it "will return 0 if no orders of a given status" do
          Item.destroy_all
          Order.destroy_all
          expect(Order.status_count_orders(item_hash["complete"])).must_equal 0
        end

        it "will return 0 if given an empty hash (ie status not in items_hash)" do
          expect(Order.status_count_orders(item_hash["no status"])).must_equal 0
        end
      end
    end
  end
end

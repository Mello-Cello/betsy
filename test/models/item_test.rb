require "test_helper"

describe Item do
  let(:item) { items(:item_1) }
  let(:product) { products(:product_1) }

  it "must be valid" do
    expect(item.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing quantity" do
      item.quantity = nil
      expect(item.valid?).must_equal false
      expect(item.errors.include?(:quantity)).must_equal true
      expect(item.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end

    it "will not be valid if quantity is zero" do
      item.quantity = 0
      expect(item.valid?).must_equal false
      expect(item.errors.include?(:quantity)).must_equal true
      expect(item.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end

    it "will not be valid if quantity is less than zero" do
      item.quantity = -1
      expect(item.valid?).must_equal false
      expect(item.errors.include?(:quantity)).must_equal true
      expect(item.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end
  end

  describe "relationships" do
    describe "relationship with an order" do
      it "will belong to an order" do
        expect(item.order).must_equal orders(:order_1)
      end
    end

    describe "relationship with an product" do
      it "will belong to an product" do
        expect(item.product).must_equal products(:product_1)
      end
    end
  end

  describe "custom methods" do
    describe "  def subtotal" do
      it "will calculate the subtotal of an item given a valid item and product" do
        expect(item.subtotal).must_equal item.quantity * product.price / 100.0
      end

      it "will return nil if item is invalid" do
        item = Item.new
        expect(item.subtotal).must_be_nil
      end

      it "will return nil if product assoctiated with item is invalid" do
        item.product = Product.new
        expect(item.subtotal).must_be_nil
      end
    end
    describe "  def available_for_purchase?" do
      it "will return true if the quantity requested is less than stock" do
        expect(item.available_for_purchase?).must_equal true
      end

      it "will return true if the quantity requested equal to stock" do
        item.update(quantity: product.stock)
        expect(item.available_for_purchase?).must_equal true
      end

      it "will return false if the quantity requested is greater than stock" do
        item.update(quantity: product.stock + 1)
        expect(item.available_for_purchase?).must_equal false
      end

      it "will return nil if item is invalid" do
        item = Item.new
        expect(item.available_for_purchase?).must_be_nil
      end

      it "will return nil if product assoctiated with item is invalid" do
        item.product = Product.new
        expect(item.available_for_purchase?).must_be_nil
      end
    end

    describe "  def purchase" do
      # tests for quantity decrease/not decreasing
      # done in product model test, custom methods section.
      it "will return true if the quantity requested is less than stock" do
        expect(item.purchase).must_equal true
      end

      it "will return true if the quantity requested equal to stock" do
        item.update(quantity: product.stock)
        expect(item.purchase).must_equal true
      end

      it "will return false if the quantity requested is greater than stock" do
        item.update(quantity: product.stock + 1)
        expect(item.purchase).must_equal false
      end

      it "will return nil if item is invalid" do
        item = Item.new
        expect(item.purchase).must_be_nil
      end

      it "will return nil if product assoctiated with item is invalid" do
        item.product = Product.new
        expect(item.purchase).must_be_nil
      end
    end
  end
end

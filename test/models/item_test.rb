require "test_helper"

describe Item do
  let(:item) { items(:item_1) }

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
end
# belongs_to :order
# belongs_to :product
# validates :quantity, presence: true
# validates_numericality_of :quantity, greater_than: 0
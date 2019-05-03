require "test_helper"

describe Product do
  let(:product) { products(:product_1) }

  it "must be valid" do
    expect(product.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing name" do
      product.name = nil
      expect(product.valid?).must_equal false 
      expect(product.errors.include?(:name)).must_equal true 
      expect(product.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "will not be valid if name is not unique" do
      product_dupe = Product.new(name: product.name, 
                                price: 222,
                                merchant: merchants(:merchant_1))
      expect(product_dupe.valid?).must_equal false
      expect(product_dupe.errors.include?(:name)).must_equal true 
      expect(product_dupe.errors.messages[:name]).must_equal ["has already been taken"]
      
      # p product_dupe.errors
    end

    it "will not be valid if missing price" do
      product.price = nil
      expect(product.valid?).must_equal false
      expect(product.errors.include?(:price)).must_equal true 
      expect(product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
    end

    it "will not be valid if price is zero" do
      product.price = 0
      expect(product.valid?).must_equal false
      expect(product.errors.include?(:price)).must_equal true 
      expect(product.errors.messages[:price]).must_equal ["must be greater than 0"]
    end

    it "will not be valid if price is less than zero" do
      product.price = -1
      expect(product.valid?).must_equal false
      expect(product.errors.include?(:price)).must_equal true 
      expect(product.errors.messages[:price]).must_equal ["must be greater than 0"]
    end
  end
  
  describe "relationships" do
    describe "relationship with merchant" do
      it "will belong to a merchant" do
        # expect(product.merchant).must_equal
      end
    end

    describe "relationship with categories" do
      it "can have 0 reviews" do
      # product.categories << categories(:product_1)
      # product.categories << categories(:product_2)
      # expect(product.categories.include?(categories(:product_1))).must_equal true
      # expect(product.categories.include?(categories(:product_2))).must_equal true
      # expect(product(:product_1).product.include?(product)).must_equal true
      end

      it "can have 1 or many reviews" do 

      end
    end

    describe "relationship with reviews" do
      it "can have 0 reviews" do
      
      end

      it "can have 1 or many reviews" do 

      end
    end

    describe "relationship with items" do

      it "can have 0 items" do
      
      end

      it "can have 1 or many items" do 

      end
    end
  end
end


# # belongs_to :merchant
# # has_and_belongs_to_many :categories
# # has_many :reviews
# # has_many :items

# # validates :name, presence: true, uniqueness: true
# # validates :price, presence: true
# # validates_numericality_of :price, greater_than: 0
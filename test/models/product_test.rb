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

    it "will not be valid if missing stock" do
      product.stock = nil
      expect(product.valid?).must_equal false
      expect(product.errors.include?(:stock)).must_equal true
      expect(product.errors.messages[:stock]).must_equal ["can't be blank", "is not a number"]
    end

    it "will be valid if stock is 0" do
      product.stock = 0
      expect(product.valid?).must_equal true
    end

    it "will not be valid if stock is less than zero" do
      product.stock = -2
      expect(product.valid?).must_equal false
      expect(product.errors.include?(:stock)).must_equal true
      expect(product.errors.messages[:stock]).must_equal ["must be greater than -1"]
    end
  end

  describe "relationships" do
    describe "relationship with merchant" do
      it "will belong to a merchant" do
        expect(product.merchant).must_equal merchants(:merchant_2)
      end
    end

    describe "relationship with categories" do
      it "can have 0 categories" do
        expect(product.categories).must_equal []
      end

      it "can have 1 or many categories" do
        product.categories << categories(:category_1)
        product.categories << categories(:category_2)
        expect(product.categories.include?(categories(:category_1))).must_equal true
        expect(product.categories.include?(categories(:category_2))).must_equal true
        expect(categories(:category_2).products.include?(product)).must_equal true
      end
    end

    describe "relationship with reviews" do
      it "can have 0 reviews" do
        product = products(:product_2)
        expect(product.reviews).must_equal []
      end

      it "can have 1 or many reviews" do
        expect(product.reviews.include?(reviews(:review_1))).must_equal true
        expect(product.reviews.include?(reviews(:review_2))).must_equal true
        expect(reviews(:review_2).product).must_equal product
      end
    end

    describe "relationship with items" do
      it "can have 0 items" do
        product = products(:product_3)
        expect(product.items).must_equal []
      end

      it "can have 1 or many items" do
        product = products(:product_2)
        expect(product.items.include?(items(:item_2))).must_equal true
        expect(product.items.include?(items(:item_3))).must_equal true
        expect(items(:item_3).product).must_equal product
      end
    end
  end

  describe "custom methods" do
    let(:initial_stock) { product.stock }
    describe "  def decrease_stock(quantity)" do
      it "will decrease the stock of a product by given quantity and return true if valid" do
        quantity = 2
        expect(initial_stock).must_equal product.stock
        expect(product.decrease_stock(quantity)).must_equal true
        expect(initial_stock).wont_equal product.stock
        expect(product.stock).must_equal initial_stock - quantity
      end

      it "will return false if quantity exceeds stock and not decrease stock" do
        quantity = 10
        expect(initial_stock).must_equal product.stock
        expect(product.decrease_stock(quantity)).must_equal false
        product.reload
        expect(initial_stock).must_equal product.stock
      end

      it "will return nil if called on invalid product" do
        product = Product.new
        quantity = 1
        expect(product.decrease_stock(quantity)).must_be_nil
      end
    end
  end
end

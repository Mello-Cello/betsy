require "test_helper"

describe Category do
  let(:category) { categories(:category_1) }

  it "must be valid" do
    expect(category.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing name" do
      category.name = nil
      expect(category.valid?).must_equal false
      expect(category.errors.include?(:name)).must_equal true
      expect(category.errors[:name]).must_equal ["can't be blank"]
    end

    it "will not be valid if name not unique" do
      category_dup = Category.new(name: category.name)
      expect(category_dup.valid?).must_equal false
      expect(category_dup.errors.include?(:name)).must_equal true
      expect(category_dup.errors[:name]).must_equal ["has already been taken"]
    end
  end

  describe "relationships for products" do
    it "can have 0 products" do
      expect(category.products.count).must_equal 0
    end

    it "can have one or more products" do
      category.products << products(:product_1)
      category.products << products(:product_2)
      expect(category.products.include?(products(:product_1))).must_equal true
      expect(category.products.include?(products(:product_2))).must_equal true
      expect(products(:product_1).categories.include?(category)).must_equal true
    end
  end
end


require "test_helper"

describe Review do
  let(:review) { reviews(:review_1) }

  it "must be valid" do
    expect(review.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing rating" do
      review.rating = nil
      expect(review.valid?).must_equal false
      expect(review.errors.include?(:rating)).must_equal true
      expect(review.errors[:rating]).must_equal ["can't be blank", "is not included in the list"]
    end

    it "will not be valid if rating is less than 1" do
      review.rating = -1
      expect(review.valid?).must_equal false
      expect(review.errors.include?(:rating)).must_equal true
      expect(review.errors[:rating]).must_equal ["is not included in the list"]
    end

    it "will not be valid if rating is greater than 5" do
      review.rating = 6
      expect(review.valid?).must_equal false
      expect(review.errors.include?(:rating)).must_equal true
      expect(review.errors[:rating]).must_equal ["is not included in the list"]
    end
  end
end

# belongs_to :product

# validates :rating, presence: true
# validates_inclusion_of :rating, :in => [1, 2, 3, 4, 5]

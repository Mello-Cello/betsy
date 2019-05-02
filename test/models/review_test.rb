require "test_helper"

describe Review do
  let(:review) { reviews(:review_1) }

  it "must be valid" do
    expect(review.valid?).must_be true
  end

  describe "validations" do
    it "will not be valid if missing rating" do
      # review.rating = nil 
      expect(review.valid?).must_equal false
    
    end

    it "will not be valid if rating is less than 1" do
    end

    it "will not be valid if rating is greater than 5" do
    end
  end
end

# belongs_to :product

# validates :rating, presence: true
# validates_inclusion_of :rating, :in => [1, 2, 3, 4, 5]

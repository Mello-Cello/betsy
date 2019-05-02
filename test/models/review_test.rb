require "test_helper"

describe Review do
  let(:review) { Review.new }

  it "must be valid" do
    value(review).must_be :valid?
  end
end


# belongs_to :product

# validates :rating, presence: true
# validates_inclusion_of :rating, :in => [1, 2, 3, 4, 5]
class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true
  validates_inclusion_of :rating, :in => [1, 2, 3, 4, 5]
end

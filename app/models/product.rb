class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :stock, presence: true
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :stock, greater_than: -1

  def decrease_stock(quantity)
    return unless self.valid?
    self.stock -= quantity
    return self.save
  end
end

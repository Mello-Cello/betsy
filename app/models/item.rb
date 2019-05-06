class Item < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  def subtotal
    return quantity * product.price / 100.0
  end

end

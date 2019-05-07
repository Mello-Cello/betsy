class Item < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  def subtotal
    return unless self.valid? && self.product.valid?
    return quantity * product.price / 100.0
  end

  # checks if item is are available w/ quantity selecged when checking out incase another person
  # has checked out product since current item was placed in cart.
  def available_for_purchase?
    return unless self.valid? && self.product.valid?
    return self.quantity <= product.stock
  end

  def purchase
    return unless self.valid?
    return product.decrease_stock(self.quantity)
  end
end

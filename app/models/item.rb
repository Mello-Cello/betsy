class Item < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  def subtotal
    return quantity * product.price / 100.0
  end

  # checks if item is are available w/ quantity selecged when checking out incase another person
  # has checked out product since current item was placed in cart.
  def available_for_purchase?
    return item.quantity <= product.stock
  end
end

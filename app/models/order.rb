class Order < ApplicationRecord
  has_many :items
  validates_inclusion_of :status, :in => ["pending", "paid", "complete", "cancelled"]

  def total
    return items.map do |item|
             item.subtotal
           end.sum
  end

  def cart_errors
    cart_errors = []
    items.each do |item|
      unless item.available_for_purchase?
        cart_errors << item
      end
    end
    return cart_errors
  end
end

class Order < ApplicationRecord
  has_many :items
  validates_inclusion_of :status, :in => ["pending", "paid", "complete", "cancelled"]

  def total
    return items.map do |item|
             item.subtotal
           end.sum
  end
end

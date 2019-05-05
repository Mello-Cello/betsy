class Order < ApplicationRecord
  has_many :items
  validates_inclusion_of :status, :in => ["pending", "paid", "complete", "cancelled"]
end

class Order < ApplicationRecord
  has_many :items
  validates_inclusion_of :status, :in => ["pending", "paid", "complete", "cancelled"]

  def total
    return items.map do |item|
             return unless item.valid? && item.product.valid?
             item.subtotal
           end.sum
  end

  def cart_errors
    cart_errors = []
    items.each do |item|
      return unless item.valid? && item.product.valid?
      unless item.available_for_purchase?
        cart_errors << item
      end
    end
    return cart_errors
  end

  def cart_checkout
    items.each do |item|
      return unless item.valid? && item.product.valid?
      item.purchase
    end
    return true
  end

  # stores merchant order items in hash:
  # key is order status and value is a
  # hash with order_id as key and array of items as value:
  # items_hash {
  #   "paid" => {"11": [item1, item2, item4]}, "16": [item7, item8, item14]},
  #   "complete" => {"15": [item11, item12, item17]}
  # }
  # to add more statuses to track follow items_hash template -> { "paid" => {}, "complete" => {} }
  def self.find_merchant_order_items(merchant, items_hash: {"paid" => {}, "complete" => {}})
    Order.all.each do |order|
      order.items.each do |item|
        if items_hash.include?(order.status) && item.product.merchant_id == merchant.id
          if !items_hash[order.status.to_s].include?(order.id.to_s)
            items_hash[order.status.to_s][order.id.to_s] = [item]
          else
            items_hash[order.status.to_s][order.id.to_s] << item
          end
        end
      end
    end
    return items_hash
  end

  # takes input of items_hash["status"] where status is a status in items_hash
  def self.status_revenue(item_status)
    revenue = 0
    return 0 if item_status == nil
    item_status.each do |order_id, items|
      sum = items.sum do |item|
        item.subtotal
      end
      revenue += sum
    end
    return revenue
  end
end

# takes input of items_hash["status"] where status is a status in items_hash
def self.status_count_orders(item_status)
  return item_status.sum do |order_id, items|
           items.count
         end
end

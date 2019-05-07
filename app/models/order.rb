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

  #self method for merchant dashboard
  # def self.sort_work(category)
  #   works = Work.where(category: category).to_a
  #   works.sort_by! { |work| Vote.where(work_id: work.id).length }
  #   return works.reverse
  # end

  def self.find_merchant_order_items(merchant)
    # items_hash = Hash.new()
    items_hash = {
      "paid" => {},
      "complete" => {},
    }
    Order.all.each do |order|
      order.items.each do |item|
        if items_hash.include?(order.status) && item.product.merchant_id == merchant.id
          if !items_hash[order.status.to_s].include?(order.id.to_s)
            items_hash[order.status.to_s][order.id.to_s] = [item]
          else
            items_hash[order.status.to_s][order.id.to_s] << [item]
          end
        end
      end
    end
    return items_hash
  end
end

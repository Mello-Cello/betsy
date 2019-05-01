# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"
failed_to_save = []
CSV.open("db/merchant_data.csv", headers: true).each_with_index do |line, i|
  merchant = Merchant.new(
    username: line["username"],
    email: line["email"],
    uid: line["uid"],
    provider: line["provider"],
  )
  merchant.save ? (puts "#{i + 1} merchant ") : failed_to_save << merchant
end

CSV.open("db/products_data.csv", headers: true).each_with_index do |line, i|
  merchant = Merchant.find(rand(1..Merchant.count))
  product = merchant.products.create(name: line["name"],
                                     price: line["price"],
                                     description: line["description"],
                                     photo_url: line["photo_url"],
                                     stock: line["stock"])
  product.valid? ? (puts "#{i + 1} product") : failed_to_save << product
end

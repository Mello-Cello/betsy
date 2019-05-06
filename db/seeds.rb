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
  product = merchant.products.create(name: line["name"].upcase,
                                     price: line["price"],
                                     description: line["description"],
                                     photo_url: line["photo_url"],
                                     stock: line["stock"])
  product.valid? ? (puts "#{i + 1} product") : failed_to_save << product
end

CSV.open("db/reviews_data.csv", headers: true).each_with_index do |line, i|
  product = Product.find(rand(1..Product.count))
  review = Review.new(rating: line["rating"],
                      comment: product.name + " " + line["comment"])
  product.reviews << review
  review.valid? ? (puts "#{i + 1} review") : failed_to_save << review
end

i = 0
CSV.open("db/categories_data.csv", headers: true).each do |line|
  category = Category.new(name: line["name"])
  10.times do |j|
    product = Product.find(rand(1..Product.count))
    product.categories << category unless product.categories.include?(category)
    category.valid? ? (puts "#{i += 1} category-product relationships") : failed_to_save << review
  end
end

puts "#{failed_to_save.count} failed to save"

require "faker"
require "csv"

CSV.open("products_data.csv", "w", :write_headers => true,
  :headers => ["name", "price", "description", "photo_url", "stock"]) do |csv|
    intangibles = [
      "high fives", "cup of sunshine", "bucket of sunshine", "sleep revival", "relaxation", "energy", "a good hair day", "pause time", "freshly showered", "teleport into bed", "ada starter kit", "ada best seller pack", "cup of rainbows", "puppy play pack", "kitten cuddles", "giggle party", "bestfriend time", "juicy secret", "inside joke moment", "bondfire time"
    ]
 20.times do |i|

  name = intangibles[i] 
  price = rand(500..5000)
  description = Faker::Movies::HitchhikersGuideToTheGalaxy.quote
  photo_url = "https://placekitten.com/g/200/300"
  stock = rand(1..15)

   csv << [name, price, description, photo_url, stock]
 end
end

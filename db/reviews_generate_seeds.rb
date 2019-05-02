require "faker"
require "csv"

CSV.open("db/reviews_data.csv", "w", :write_headers => true,
                                     :headers => ["rating", "comment"]) do |csv|
  intangibles = [
    "high fives", "cup of sunshine", "bucket of sunshine", "sleep revival", "relaxation", "energy", "a good hair day", "pause time", "freshly showered", "teleport into bed", "ada starter kit", "ada best seller pack", "cup of rainbows", "puppy play pack", "kitten cuddles", "giggle party", "bestfriend time", "juicy secret", "inside joke moment", "bondfire time",
  ]
  40.times do |i|
    index = rand(0...20)
    rating = rand(1..5)
    if rating > 3
      comment = "#{intangibles[index].capitalize} brightened my day. It was also promises to make shooting daytime and nighttime action simpler and professional-looking, providing the budding photographer with new and enticing reasons to hone their skills."
    else
      comment = "#{intangibles[index].capitalize} design does not hold up on rugged use and did not reduce fatique. "
    end
    csv << [rating, comment]
  end
end

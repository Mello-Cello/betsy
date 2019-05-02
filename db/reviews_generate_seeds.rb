require "faker"
require "csv"

CSV.open("db/reviews_data.csv", "w", :write_headers => true,
                                     :headers => ["rating", "comment"]) do |csv|
  40.times do |i|
    rating = rand(1..5)
    if rating > 3
      comment = " brightened my day. It was also promises to make shooting daytime and nighttime action simpler and professional-looking, providing the budding photographer with new and enticing reasons to hone their skills."
    else
      comment = " design does not hold up on rugged use and did not reduce fatique."
    end
    csv << [rating, comment]
  end
end

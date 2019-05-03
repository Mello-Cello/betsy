require "csv"

categories = ["Fun times", "Rejunivation", "Happiness", "Magical", "Imagination"]

CSV.open("db/categories_data.csv", "w", :write_headers => true,
                                        :headers => ["name"]) do |csv|
  5.times do |i|
    category = categories[i]
    csv << [category]
  end
end

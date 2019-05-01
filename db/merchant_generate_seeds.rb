require "faker"
require "csv"

# we already provide a filled out media_seeds.csv file, but feel free to
# run this script in order to replace it and generate a new one
# run using the command:
# $ ruby db/generate_seeds.rb
# if satisfied with this new media_seeds.csv file, recreate the db with:
# $ rails db:reset
# doesn't currently check for if titles are unique against each other

CSV.open("merchant_data.csv", "w", :write_headers => true,
                                   :headers => ["username", "email", "uid", "provider"]) do |csv|
  5.times do
    username = Faker::Games::Pokemon.unique.name
    email = Faker::Internet.unique.email
    uid = Faker::Number.unique.number(5)
    provider = "github"
    csv << [username, email, uid, provider]
  end
end

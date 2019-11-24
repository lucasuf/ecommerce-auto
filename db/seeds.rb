# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
    Order.create({
        reference: Faker::Code.nric,
        purchase_channel: 'Site BR',
        client_name: Faker::TvShows::Friends.character,
        adress: Faker::Address.full_address,
        delivery_service: 'SEDEX',
        total_value: Faker::Commerce.price,
        line_items: Faker::Beer.name,
    })
end

10.times do
    Order.create({
        reference: Faker::Code.nric,
        purchase_channel: 'Site BR',
        client_name: Faker::TvShows::Friends.character,
        adress: Faker::Address.full_address,
        delivery_service: 'Amazon',
        total_value: Faker::Commerce.price,
        line_items: Faker::Beer.name,
    })
end

10.times do
    Order.create({
        reference: Faker::Code.nric,
        purchase_channel: 'Site EUR',
        client_name: Faker::TvShows::Friends.character,
        adress: Faker::Address.full_address,
        delivery_service: 'Amazon',
        total_value: Faker::Commerce.price,
        line_items: Faker::Beer.name,
    })
end
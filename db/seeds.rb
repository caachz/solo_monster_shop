# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

MerchantEmployee.destroy_all
ItemOrder.destroy_all
Order.destroy_all
Merchant.destroy_all
Item.destroy_all
User.destroy_all


#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#user
user1 = User.create(name: 'Benny1', street_address: '1234 Main St.', city: 'Denver', state: 'CO', zip: '80144', email: 'user@email.com', password: 'password', password_confirmation: 'password')
user2 = User.create(name: 'Benny2', street_address: '1234 Main St.', city: 'Denver', state: 'CO', zip: '80144', email: 'user2@email.com', password: 'password', password_confirmation: 'password')
user3 = User.create(name: 'Benny3', street_address: '1234 Main St.', city: 'Denver', state: 'CO', zip: '80144', email: 'user3@email.com', password: 'password', password_confirmation: 'password')
merchant = User.create(name: 'Benny', street_address: '1234 Main St.', city: 'Denver', state: 'CO', zip: '80144', role: 1, email: 'merchant@email.com', password: 'password', password_confirmation: 'password')
bike_shop.users << merchant

admin = User.create(name: 'Benny', street_address: '1234 Main St.', city: 'Denver', state: 'CO', zip: '80144', role: 2, email: 'admin@email.com', password: 'password', password_confirmation: 'password')

order = Order.create!(name: "Kelly", address: "2233 Nothing st", city: "Nowhere", state: "NO", zip: "12345", user: user1)
order2 = Order.create!(name: "Kelly", address: "2233 Nothing st", city: "Nowhere", state: "NO", zip: "12345", user: user1)
order3 = Order.create!(name: "Kelly", address: "2233 Nothing st", city: "Nowhere", state: "NO", zip: "12345", user: user2)
order4 = Order.create!(name: "Kelly", address: "2233 Nothing st", city: "Nowhere", state: "NO", zip: "12345", user: user3)

ItemOrder.create(price: pull_toy.price, quantity: 7, order: order, item: pull_toy)
ItemOrder.create(price: dog_bone.price, quantity: 2, order: order, item: dog_bone)
ItemOrder.create(price: tire.price, quantity: 2, order: order, item: tire)

ItemOrder.create(price: pull_toy.price, quantity: 3, order: order2, item: pull_toy, status: 1)
ItemOrder.create(price: tire.price, quantity: 9, order: order2, item: tire, status: 1)

ItemOrder.create(price: pull_toy.price, quantity: 1, order: order3, item: pull_toy)
ItemOrder.create(price: dog_bone.price, quantity: 20, order: order3, item: dog_bone)
ItemOrder.create(price: tire.price, quantity: 3, order: order3, item: tire)

ItemOrder.create(price: pull_toy.price, quantity: 5, order: order4, item: pull_toy)
ItemOrder.create(price: dog_bone.price, quantity: 4, order: order4, item: dog_bone)

Discount.create!(merchant: bike_shop, quantity: 10, discount: 10)
Discount.create!(merchant: bike_shop, quantity: 20, discount: 20)

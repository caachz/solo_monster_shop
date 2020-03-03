require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "#calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "#sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it '#no orders' do
      user = create(:user)
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it '#discount' do
      discount1 = Discount.create!(merchant: @bike_shop, quantity: 3, discount: 10)

      expect(@chain.discount(2)).to eq(nil)
      expect(@chain.discount(3)).to eq(discount1)
    end

    it '#discounted_price' do
      discount1 = Discount.create!(merchant: @bike_shop, quantity: 3, discount: 10)

      expect(@chain.discounted_price(2)).to eq(50)
      expect(@chain.discounted_price(3)).to eq(45.0)
    end

  it ".topfive" do
    user = create(:user)

    bike_basket = @bike_shop.items.create!(name: "Bike Basket", description: "A place to put your junk.", price: 30, image: "https://images-na.ssl-images-amazon.com/images/I/4147WWbN64L._SX466_.jpg", inventory: 7)
    bike_horn = @bike_shop.items.create!(name: "Bike Horn", description: "A truck horn for your bike!", price: 80, image: "https://images-na.ssl-images-amazon.com/images/I/4147WWbN64L._SX466_.jpg", inventory: 7)
    bike_seat = @bike_shop.items.create!(name: "Bike Seat", description: "Super comfy!", price: 80, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 7)
    shifter = @bike_shop.items.create!(name: "Shimano Shifters", description: "It'll always shift!", price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 7)

    order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)

    order.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
    order.item_orders.create!(item: bike_basket, price: 3, quantity: 5)
    order.item_orders.create!(item: bike_horn, price: 3, quantity: 7)
    order.item_orders.create!(item: bike_seat, price: 3, quantity: 12)
    order.item_orders.create!(item: shifter, price: 3, quantity:2)

    expect(Item.topfive[0].name).to eq("Bike Seat")
    expect(Item.topfive[0].quantity).to eq(12)
    expect(Item.topfive[1].name).to eq("Bike Horn")
    expect(Item.topfive[1].quantity).to eq(7)
    expect(Item.topfive[2].name).to eq("Bike Basket")
    expect(Item.topfive[2].quantity).to eq(5)
    expect(Item.topfive[3].quantity).to eq(2)
    expect(Item.topfive[4].quantity).to eq(2)
  end

  it ".bottomfive" do
    user = create(:user)

    bike_basket = @bike_shop.items.create!(name: "Bike Basket", description: "A place to put your junk.", price: 30, image: "https://images-na.ssl-images-amazon.com/images/I/4147WWbN64L._SX466_.jpg", inventory: 7)
    bike_horn = @bike_shop.items.create!(name: "Bike Horn", description: "A truck horn for your bike!", price: 80, image: "https://images-na.ssl-images-amazon.com/images/I/4147WWbN64L._SX466_.jpg", inventory: 7)
    bike_seat = @bike_shop.items.create!(name: "Bike Seat", description: "Super comfy!", price: 80, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 7)
    shifter = @bike_shop.items.create!(name: "Shimano Shifters", description: "It'll always shift!", price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 7)

    order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)

    order.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
    order.item_orders.create!(item: bike_basket, price: 3, quantity: 5)
    order.item_orders.create!(item: bike_horn, price: 3, quantity: 7)
    order.item_orders.create!(item: bike_seat, price: 3, quantity: 12)
    order.item_orders.create!(item: shifter, price: 3, quantity:2)

    expect(Item.bottomfive[0].quantity).to eq(2)
    expect(Item.bottomfive[1].quantity).to eq(2)
    expect(Item.bottomfive[2].name).to eq("Bike Basket")
    expect(Item.bottomfive[2].quantity).to eq(5)
    expect(Item.bottomfive[3].name).to eq("Bike Horn")
    expect(Item.bottomfive[3].quantity).to eq(7)
    expect(Item.bottomfive[4].name).to eq("Bike Seat")
    expect(Item.bottomfive[4].quantity).to eq(12)
  end
end
end

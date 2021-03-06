require 'rails_helper'

RSpec.describe 'Bulk discounts applied in cart' do
  describe 'When I have enough of an item in my cart' do
    it "I see a discount applied to only that item" do
      merchant1 = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant2 = Merchant.create!(name: "Monsters Inc Shoppe", address: '334 nothing st', city: 'Moab', state: 'UT', zip: 48903)

      discount1 = Discount.create!(merchant: merchant1, quantity: 3, discount: 10)

      item1 = merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      item2 = merchant1.items.create(name: "stuffed octopus", description: "snuggle bunnt", price: 64, image: "https://images-na.ssl-images-amazon.com/images/I/61yTBRbtvrL._AC_SY355_.jpg", inventory: 12)
      item3 = merchant2.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit "/items/#{item2.id}"
      click_on "Add To Cart"

      visit "/items/#{item3.id}"
      click_on "Add To Cart"

      visit "/cart"

      within "#cart-item-#{item2.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$64.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$128.00")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$172.80")
        expect(page).to have_content("10% discount applied")
      end

      within "#cart-item-#{item1.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$20.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$40.00")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$54.00")
        expect(page).to have_content("10% discount applied")
      end

      within "#cart-item-#{item3.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content('$2.00')
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content('$4.00')
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content('$6.00')
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content('$8.00')
        expect(page).to_not have_content("10% discount applied")
      end
      expect(page).to have_content('Total: $234.80')
    end

    it "I can have many bulk discounts and only the highest discount will apply" do
      merchant1 = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      discount1 = Discount.create!(merchant: merchant1, quantity: 3, discount: 10)
      discount1 = Discount.create!(merchant: merchant1, quantity: 6, discount: 20)

      item1 = merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      item2 = merchant1.items.create(name: "stuffed octopus", description: "snuggle bunnt", price: 64, image: "https://images-na.ssl-images-amazon.com/images/I/61yTBRbtvrL._AC_SY355_.jpg", inventory: 12)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit "/items/#{item2.id}"
      click_on "Add To Cart"

      visit "/cart"

      within "#cart-item-#{item2.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$64.00")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$128.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$172.80")
        expect(page).to have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content("$230.40")
        click_on "Add Quantity"
        expect(page).to have_content('5')
        expect(page).to have_content("$288.00")
        expect(page).to have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('6')
        expect(page).to have_content("$307.20")
        expect(page).to have_content("20% discount applied")
      end

      within "#cart-item-#{item1.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$20.00")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$40.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$54.00")
        expect(page).to have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content("$72.00")
        click_on "Add Quantity"
        expect(page).to have_content('5')
        expect(page).to have_content("$90.00")
        click_on "Add Quantity"
        expect(page).to have_content('6')
        expect(page).to have_content("$96.00")
        expect(page).to have_content("20% discount applied")
      end
    end

    it "I can have multiple different discounts for different quantities of items" do
      merchant1 = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      discount1 = Discount.create!(merchant: merchant1, quantity: 3, discount: 10)
      discount1 = Discount.create!(merchant: merchant1, quantity: 6, discount: 20)

      item1 = merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      item2 = merchant1.items.create(name: "stuffed octopus", description: "snuggle bunnt", price: 64, image: "https://images-na.ssl-images-amazon.com/images/I/61yTBRbtvrL._AC_SY355_.jpg", inventory: 12)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit "/items/#{item2.id}"
      click_on "Add To Cart"

      visit "/cart"

      within "#cart-item-#{item2.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$64.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$128.00")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$172.80")
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content("$230.40")
        expect(page).to have_content("10% discount applied")
      end

      within "#cart-item-#{item1.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$20.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$40.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$54.00")
        expect(page).to have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content("$72.00")
        click_on "Add Quantity"
        expect(page).to have_content('5')
        expect(page).to have_content("$90.00")
        click_on "Add Quantity"
        expect(page).to have_content('6')
        expect(page).to have_content("$96.00")
        expect(page).to have_content("20% discount applied")
      end
    end

    it "If I meet the threshold for the highest discount rate I only see that discount applied" do
      merchant1 = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      discount1 = Discount.create!(merchant: merchant1, quantity: 3, discount: 10)
      discount1 = Discount.create!(merchant: merchant1, quantity: 6, discount: 20)

      item1 = merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit "/cart"

      within "#cart-item-#{item1.id}" do
        expect(page).to have_content('1')
        expect(page).to have_content("$20.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('2')
        expect(page).to have_content("$40.00")
        expect(page).to_not have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('3')
        expect(page).to have_content("$54.00")
        expect(page).to have_content("10% discount applied")
        click_on "Add Quantity"
        expect(page).to have_content('4')
        expect(page).to have_content("$72.00")
        click_on "Add Quantity"
        expect(page).to have_content('5')
        expect(page).to have_content("$90.00")
        click_on "Add Quantity"
        expect(page).to have_content('6')
        expect(page).to have_content("$96.00")
        expect(page).to have_content("20% discount applied")
      end
    end
  end
end

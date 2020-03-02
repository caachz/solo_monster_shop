require 'rails_helper'

RSpec.describe "As an merchant employee,", type: :feature do
  describe "when I visit my merchants dashboard" do
    it "A link takes me to my bulk discounts page" do
      user = create(:user, role: 1)

      mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      mike = Merchant.create!(name: "Monsters Inc Shoppe", address: '334 nothing st', city: 'Moab', state: 'UT', zip: 48903)

      mike.users << user

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      discount1 = Discount.create!(merchant: mike, quantity: 20, discount: 20)
      discount1 = Discount.create!(merchant: mike, quantity: 10, discount: 10)
      discount1 = Discount.create!(merchant: mike, quantity: 5, discount: 5)

      visit '/merchant'

      click_link('Bulk Discounts')

      expect(current_path).to eq("/merchant/discounts/#{mike.id}")

      expect(page).to have_content('Discount 20% on 20 items or more')
      expect(page).to have_content('Discount 10% on 10 items or more')
      expect(page).to have_content('Discount 5% on 5 items or more')

    end

    it "On my bulk discounts page I can create a new bulk discount" do
    end

    it "On my bulk discounts page I can edit an existing bulk discount" do
    end

    it "On my bulk discounts page I can delete an existing bulk discount" do
    end

    it "I can have many bulk discounts and only the highest discount will apply" do
    end
  end
end

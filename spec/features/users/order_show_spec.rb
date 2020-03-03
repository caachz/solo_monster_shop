require 'rails_helper'

RSpec.describe 'User Order Show Page', type: :feature do
  before :each do
    @user = create(:user)
    @bone = create(:item)
    @bone2 = create(:item, name: "bone2")
    @bone3 = create(:item, name: "bone3")
    @order1 = @user.orders.create(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: 1, user: @user)
    @order1.item_orders.create!(item: @bone, price: @bone.price, quantity: 2)
    @order1.item_orders.create!(item: @bone2, price: @bone2.price, quantity: 4)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'should show a break down of the order information' do
    visit "/profile/orders/#{@order1.id}"

    expect(page).to have_content("Order #{@order1.id}")
    expect(page).to have_content(@order1.creation)
    expect(page).to have_content(@order1.updated)
    expect(page).to have_content("Pending")
    expect(page).to have_content("Total Items: #{@order1.total_items}")
    expect(page).to have_content("Order Total Cost: $60.00")

    within "#item-#{@bone.id}" do
      expect(page).to have_content(@bone.name)
      expect(page).to have_css("img[src*='#{@bone.image}']")
      expect(page).to have_content("$10.00")
      expect(page).to have_content("$20.00")
      expect(page).to have_content(@bone.description)
      expect(page).to have_content("2")
    end

    within "#item-#{@bone2.id}" do
      expect(page).to have_content(@bone2.name)
      expect(page).to have_css("img[src*='#{@bone2.image}']")
      expect(page).to have_content("$10.00")
      expect(page).to have_content("$40.00")
      expect(page).to have_content(@bone2.description)
      expect(page).to have_content("4")
    end
  end

end

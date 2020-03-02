class Merchant <ApplicationRecord
  has_many :discounts
  has_many :merchant_employees
  has_many :users, through: :merchant_employees
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_inclusion_of :enabled?, :in => [true, false]


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def deactivate_items
    items.update(active?: false)
  end

  def activate_items
    items.update(active?: true)
  end

end

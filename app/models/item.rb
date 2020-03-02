class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def discount(quantity)
    merchant.discounts.where("discounts.quantity <= #{quantity}").order("discounts.quantity DESC").first
  end

  def self.topfive
    joins(:item_orders).group(:id).order('SUM(item_orders.quantity)DESC').limit(5).select('items.*, SUM(item_orders.quantity) as quantity')
  end

  def self.bottomfive
    left_outer_joins(:item_orders).group(:id).order('SUM(item_orders.quantity) ASC NULLS FIRST').limit(5).select('items.*, COALESCE(SUM(item_orders.quantity), 0) as quantity')
  end

end

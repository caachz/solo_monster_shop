class Discount < ApplicationRecord
  validates_presence_of :merchant, :quantity, :discount

  belongs_to :merchant
end

class Merchant::DiscountsController < ApplicationController
  def show
    @discounts = Discount.where("merchant_id = #{params[:id]}")
  end
end

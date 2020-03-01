class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = Discount.where("merchant_id = #{current_user.merchants.first.id}")
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchants.first
    discount = Discount.new(discount_params)
    merchant.discounts << discount
    if discount.save
      flash[:notice] = "A bulk discount of #{discount.discount} has been added to your shop"
      redirect_to merchant_discounts_path
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def discount_params
      params.require(:discount).permit(:quantity, :discount)
    end
end

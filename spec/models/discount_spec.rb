require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :merchant }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :discount }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end

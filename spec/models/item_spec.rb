require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "class methods" do
    describe ".find_by_price_range" do
      it "returns items within the price range" do
        merchant = create(:merchant)
        item_1 = create(:item, merchant: merchant, unit_price: 1.00)
        item_2 = create(:item, merchant: merchant, unit_price: 2.00)
        item_3 = create(:item, merchant: merchant, unit_price: 3.00)
        item_4 = create(:item, merchant: merchant, unit_price: 4.00)
        item_5 = create(:item, merchant: merchant, unit_price: 5.00)

        expect(Item.find_by_price_range(2.00, 4.00)).to eq([item_2, item_3, item_4])
      end
    end
  end
end
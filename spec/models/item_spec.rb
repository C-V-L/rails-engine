require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe "class methods" do
    describe '.search_by_name' do
      it 'returns an item if the name is an exact match' do
        merc = create(:merchant)
        item = create(:item, name: "Pizza", merchant: merc)

        expect(Item.search_by_name("Pizza")).to eq([item])
      end

      it 'returns an all items if the name is a partial match' do
        merc = create(:merchant)
        item = create(:item, name: "Pizza", merchant: merc)
        item2= create(:item, name: "Pizzazz", merchant: merc)

        expect(Item.search_by_name("Piz")).to eq([item, item2])
      end

      it 'returns nothing if the name does not match' do
        merc = create(:merchant)
        item = create(:item, name: "Pizza", merchant: merc)

        expect(Item.search_by_name("Cheese")).to eq([])
      end
    end

    describe ".find_by_price_range" do
      before :each do
        merchant = create(:merchant)
        @item_1 = create(:item, merchant: merchant, unit_price: 1.00)
        @item_2 = create(:item, merchant: merchant, unit_price: 2.00)
        @item_3 = create(:item, merchant: merchant, unit_price: 3.00)
        @item_4 = create(:item, merchant: merchant, unit_price: 4.00)
        @item_5 = create(:item, merchant: merchant, unit_price: 5.00)
      end
      it "returns items within the price range" do
        params = { min_price: 2.00, max_price: 4.00 }

        expect(Item.find_by_price_range(params)).to eq([@item_2, @item_3, @item_4])
      end

      it 'can return all items above a minimum price' do
        params = { min_price: 2.00 }

        expect(Item.find_by_price_range(params)).to eq([@item_2, @item_3, @item_4, @item_5])
      end

      it 'can return all items below a maximum price' do
        params = { max_price: 4.00 }

        expect(Item.find_by_price_range(params)).to eq([@item_1, @item_2, @item_3, @item_4])
      end

      it 'can return empty data if min price too high' do
        params = { min_price: 6.00 }

        expect(Item.find_by_price_range(params)).to eq([])
      end

      it 'can return all if no params passed' do
        params = {}
        expect(Item.find_by_price_range(params)).to eq([@item_1, @item_2, @item_3, @item_4, @item_5])
      end
    end
  end
end
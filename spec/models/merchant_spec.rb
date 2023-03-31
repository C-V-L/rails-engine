require 'rails_helper'

RSpec.describe Merchant, type: :model do
	
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "class methods" do
    describe ".search_by_name" do
      it "returns a merchant if the name is an exact match" do
        merchant = create(:merchant, name: "Pizza Shop")

        expect(Merchant.search_by_name("Pizza Shop")).to eq(merchant)
      end

      it "returns a merchant if the name is a partial match" do
        merchant = create(:merchant, name: "Pizza Shop")

        expect(Merchant.search_by_name("Pizza")).to eq(merchant)
      end

      it "returns a merchant if the name is a case-insensitive match" do
        merchant = create(:merchant, name: "Pizza Shop")

        expect(Merchant.search_by_name("PiZZa")).to eq(merchant)
      end

      it "returns nil if the name does not match" do
        create(:merchant, name: "Pizza Shop")

        expect(Merchant.search_by_name("Cheese Burgers In Paradise")).to eq(nil)
      end
    end
  end
end
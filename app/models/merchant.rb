class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, -> { distinct }, through: :invoices  
  has_many :transactions, -> { distinct }, through: :invoices
  has_many :bulk_discounts, dependent: :destroy

  def self.search_by_name(search_name)
    where("lower(name) LIKE lower('%#{search_name}%')").order(:name).first
  end
end

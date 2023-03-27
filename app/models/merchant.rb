class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, -> { distinct }, through: :invoices  
  has_many :transactions, -> { distinct }, through: :invoices
  has_many :bulk_discounts, dependent: :destroy

end

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :customers, through: :invoices, dependent: :destroy
  has_many :transactions, through: :invoices, dependent: :destroy
  
  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, greater_than: 0, only_float: true

  def self.find_by_price_range(params)
    if params[:min_price] && params[:max_price]
      where("unit_price >= ? AND unit_price <= ?", params[:min_price], params[:max_price])
    elsif params[:min_price]
      where("unit_price >= ?", params[:min_price])
    elsif params[:max_price]
      where("unit_price <= ?", params[:max_price])
    else
      all
    end
  end

  def self.search_by_name(search_name)
    where("lower(name) LIKE lower('%#{search_name}%')").order(:name)
  end
end

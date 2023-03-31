class Api::V1::ItemsFindController < ApplicationController
  def index
    items = Item.find_by_price_range(params)
    if !items.empty?
      render json: ItemSerializer.new(Item.find_by_price_range(params))
    else 
      render json: { data: {} }
    end
  end
end
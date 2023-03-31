class Api::V1::ItemsFindController < ApplicationController
  def index
    items = Item.find_by_price_range(params[:min_price], params[:max_price])
    if !items.empty?
      render json: ItemSerializer.new(Item.find_by_price_range(params[:min_price], params[:max_price]))
    else 
      render json: { data: {} } 
    end
  end
end
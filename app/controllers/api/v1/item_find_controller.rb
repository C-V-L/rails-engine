class Api::V1::ItemFindController < ApplicationController
  def index
    items = Item.find_by_price_range(params[:min_price], params[:max_price])
    if !items.empty?
      items.each do |item|
        render json: ItemSerializer.new(item)
      end
    else 
      render json: { data: {} }, status: 404  
    end
  end
end
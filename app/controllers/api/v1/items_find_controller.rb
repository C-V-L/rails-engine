class Api::V1::ItemsFindController < ApplicationController
  before_action :min_price_check, only: [:index]
  before_action :max_price_check, only: [:index]

  def index
    if params[:name]
      render json: ItemSerializer.new(Item.search_by_name(params[:name]))
    elsif params[:min_price] || params[:max_price]
      render json: ItemSerializer.new(Item.find_by_price_range(params))
    else
      render json: { data: {} }
    end
    # items = Item.find_by_price_range(params)
    # if !items.empty?
    #   render json: ItemSerializer.new(Item.find_by_price_range(params))
    # else 
    #   render json: { data: {} }
  end
end
class Api::V1::ItemsFindController < ApplicationController
  before_action :price_check, only: [:index]
  before_action :name_price_mix_check, only: [:index]
  def index
    if params[:name]
      render json: ItemSerializer.new(Item.search_by_name(params[:name]))
    elsif params[:min_price] || params[:max_price]
      render json: ItemSerializer.new(Item.find_by_price_range(params))
    else
      render json: ItemSerializer.new(Item.find_by_price_range(params))
    end
  end
end
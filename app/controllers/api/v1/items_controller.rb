class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    begin
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end

  def create
    begin
      render json: ItemSerializer.new(Item.create!(item_params)), status: 201
    end
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: ItemSerializer.new(item).serializable_hash.to_json
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
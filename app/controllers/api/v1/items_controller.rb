class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save 
      render json: ItemSerializer.new(Item.create!(item_params)), status: 201
    else
      render json: {error: "Item not created"}, status: 400
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
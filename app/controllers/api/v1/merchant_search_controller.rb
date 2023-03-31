class Api::V1::MerchantSearchController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])

    if merchant.nil?
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    else 
      render json: MerchantSerializer.new(merchant)
    end
  end
end
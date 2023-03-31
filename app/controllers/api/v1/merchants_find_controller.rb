class Api::V1::MerchantsFindController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])
    if !merchant.nil?
      render json: MerchantSerializer.new(Merchant.search_by_name(params[:name]))
    else
      render json: { "data": {} }
    end
  end
end
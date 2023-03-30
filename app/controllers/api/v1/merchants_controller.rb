class Api::V1::MerchantsController < ApplicationController

  def index
    begin
    render json: MerchantSerializer.new(Merchant.all)
    end
  end

  def show
    begin 
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

end
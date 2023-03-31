class Api::V1::MerchantFindController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])
    if !merchant.nil?
      render json: MerchantSerializer.new(Merchant.search_by_name(params[:name]))
    else ActiveRecord::RecordNotFound
      render json: {errors: [{status: "404", title: "No Record Found"}]}, status: 404
    end
  end
end
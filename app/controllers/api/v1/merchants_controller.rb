class Api::V1::MerchantsController < ApplicationController
  def index
    page 
    per_page
    api_page_info(MerchantSerializer, Merchant)

    render json: @serial
  end

  def show
    @merchant = MerchantSerializer.new(Merchant.find(params[:id]))
    render json: @merchant
  end
end

class Api::V1::ItemMerchantsController < ApplicationController
  def show 
    @item = Item.find(params[:id])
    @merchant = MerchantSerializer.new(Merchant.find(@item.merchant_id))
    render json: @merchant
  end
end
class Api::V1::MerchantItemsController < ApplicationController
  def index 
    @items = Merchant.find(params[:id]).items
    @serial = ItemSerializer.new(@items)
    render json: @serial
  end
end
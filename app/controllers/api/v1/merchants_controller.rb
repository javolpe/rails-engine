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

  def single_revenue 
    @merchant = Merchant.find(params[:id])
    @serial = MerchantRevenueSerializer.new(@merchant)
    render json: @serial
  end

  def revenue_sorted
    quantity = params[:quantity].to_i if params[:quantity] 
    if quantity.to_i <= 0 || params[:quantity].nil?
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render json: { error: error}, status: :bad_request
    else 
      @merchants = Merchant.sorted_by_revenue(quantity)
      @serial = MerchantNameRevenueSerializer.new(@merchants)
      render json: @serial
    end
  end
end

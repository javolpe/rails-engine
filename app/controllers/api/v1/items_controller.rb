class Api::V1::ItemsController < ApplicationController
  def index
    page 
    per_page
    api_page_info(ItemSerializer, Item)
    render json: @serial
  end

  def show
    @item = ItemSerializer.new(Item.find(params[:id]))
    render json: @item
  end

  def create 
    @item =  Item.create!(item_params)
    @serial = ItemSerializer.new(@item)
    if @item.save
      render json: @serial, status: :created
    end
  end

  def update 
    @item = Item.find(params[:id])
    @item.update!(item_params)
    @serial = ItemSerializer.new(@item)
    render json: @serial, status: 200
  end

  def destroy 
    @item = Item.find(params[:id])
    invoices = @item.invoices.joins(:invoice_items).having('count(invoices.*) = 1').group('invoices.id').pluck(:id)
    Invoice.destroy(invoices)
    Item.find(params[:id]).destroy
  end

  def highest_revenue 
    quantity = params[:quantity].nil? ? 10 : params[:quantity].to_i
    if quantity.to_i <= 0 
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render json: { error: error}, status: :bad_request
    else
      @items = Item.sorted_by_revenue(quantity)
      @serial = ItemRevenueSerializer.new(@items)
      render json: @serial
    end
  end

  private 
  def item_params 
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end

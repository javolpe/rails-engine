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
    Item.find(params[:id]).destroy
  end

  private 
  def item_params 
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end

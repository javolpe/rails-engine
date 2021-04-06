class Api::V1::Items::SearchController < ApplicationController
  def show 
    search_term = params[:name].downcase
    item = Item.find_one_by_name_fragment(search_term)
    @item = ItemSerializer.new(item)
    if item
      render json: @item
    else
       render json: { data: {} }
    end
  end
end
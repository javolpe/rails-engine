class Items::SearchFacade 
  def show
    min_price = params[:min_price] ; max_price = params[:max_price]
  if params[:name] && (params[:min_price] || params[:max_price])
    render json: { error: "please send name or min and or max price" }, status: :bad_request
  elsif params[:name]
    find_item_by_name(params[:name].downcase)
  elsif params[:min_price] && params[:max_price]
    find_item_by_max_and_min_price(min_price, max_price)
  elsif params[:max_price]
    find_item_by_max_price(max_price)
  elsif params[:min_price]
    find_item_by_min_price(min_price)
  else
    render json: { error: "please send a query parameter"}, status: :bad_request
  end
end



private 

  def find_item_by_name(name)
  search_term = name
  item = Item.find_one_by_name_fragment(search_term)
  if item
    render json: ItemSerializer.new(item)
  else
    render json: {data: {}}
  end
  end

  def find_item_by_max_and_min_price(min_price, max_price)
  min_price = min_price.to_f ; max_price = max_price.to_f
  item = Item.where('unit_price <= ?', max_price ).where('unit_price >= ?', min_price).order(:name).limit(1).first
  if min_price > max_price
    render json: { error: "max price cannot less than 0"}, status: :bad_request
  elsif item
    render json: ItemSerializer.new(item)
  else
    render json: {data: {}}
  end
  end

  def find_item_by_max_price(max_price)
  max_price = max_price.to_f
  item = Item.where('unit_price <= ?', max_price ).order(:name).limit(1).first
  if max_price < 0
    render json: { error: "max price cannot less than 0"}, status: :bad_request
  elsif item
    render json: ItemSerializer.new(item)
  else
    render json: {data: {}}
  end
  end

  def find_item_by_min_price(min_price)
  min_price = min_price.to_f
  item = Item.where('unit_price >= ?', min_price).order(:name).limit(1).first
  if min_price < 0
    render json: { error: "min price cannot less than 0"}, status: :bad_request
  elsif item
    render json: ItemSerializer.new(item)
  else
    render json: {data: {}}
  end

end
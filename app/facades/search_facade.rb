class SearchFacade 
  def self.return_result_of_search(name, min_price, max_price)
    if name && (min_price || max_price)
       { error: "please send name or min and or max price", status: :bad_request }
    elsif name
      find_item_by_name(name.downcase)
    elsif min_price && max_price
      find_item_by_max_and_min_price(min_price, max_price)
    elsif max_price
      find_item_by_max_price(max_price)
    elsif min_price
      find_item_by_min_price(min_price)
    else
      { error: "please send a query parameter", status: :bad_request}
    end
  end




private 

  def find_item_by_name(name)
    search_term = name
    item = Item.find_one_by_name_fragment(search_term)
    if item
       item
    else
       {data: {}}
    end
  end

  def find_item_by_max_and_min_price(min_price, max_price)
    min_price = min_price.to_f ; max_price = max_price.to_f
    item = Item.where('unit_price <= ?', max_price ).where('unit_price >= ?', min_price).order(:name).limit(1).first
    if min_price > max_price
       { error: "max price cannot less than 0", status: :bad_request}
    elsif item
       item
    else
       {data: {}}
    end
  end

  def find_item_by_max_price(max_price)
    max_price = max_price.to_f
    item = Item.where('unit_price <= ?', max_price ).order(:name).limit(1).first
    if max_price < 0
       { error: "max price cannot less than 0", status: :bad_request}
    elsif item
       item
    else
       {data: {}}
    end
  end

  def find_item_by_min_price(min_price)
    min_price = min_price.to_f
    item = Item.where('unit_price >= ?', min_price).order(:name).limit(1).first
    if min_price < 0
       { error: "min price cannot less than 0", status: :bad_request}
    elsif item
       item
    else
      {data: {}}
    end
  end

end
require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
    create_list(:merchant, 2)
  end
  
  it "can create one item" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    unit_price: 123.45,
                                    merchant_id: Merchant.first.id
                                    }
    
    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
  
    expect(response.status).to eq(201)
    expect(Item.all.size).to eq(91)
    expect(Item.last.name).to eq('Shiny Itemy Item')
  end
  it "can not create an item if any attribute is missing" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    merchant_id: Merchant.first.id
                                    }
    
    expect(response).not_to be_successful
    expect(response.status).to eq(404)
  end
  it "can not create an item if there are extra attributes" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    unit_price: 123.45,
                                    merchant_id: Merchant.first.id,
                                    something: "extra"
                                    }
    
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(Item.all.size).to eq(91)
    expect(Item.last.name).to eq('Shiny Itemy Item')
  end
  it "can delete one item" do 
    expect(Item.all.size).to eq(90)
    delete "/api/v1/items/#{Item.first.id}"
    expect(response).to be_successful
  
    expect(response.status).to eq(204)
    expect(Item.all.size).to eq(89)
  end
end
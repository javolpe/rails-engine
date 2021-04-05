require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
    create_list(:merchant, 2)
  end
  it "can update one item if given a valid item id" do 
    patch "/api/v1/items/#{Item.first.id}", params: { name: 'Shiny Itemy Item',
      description: "It does a lot things pretty good",
      unit_price: 123.45,
      merchant_id: Merchant.first.id
      }

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(200)
    expect(Item.first.name).to eq('Shiny Itemy Item')
    expect(Item.first.description).to eq("It does a lot things pretty good")
  end
  it "returns 404 if given a not valid item id" do 
    invalid_id = Item.first.id
    patch "/api/v1/items/invalid_id", params: { name: 'Shiny Itemy Item',
                                                description: "It does a lot things pretty good",
                                                unit_price: 123.45,
                                                merchant_id: Merchant.first.id
                                                }

    expect(response).not_to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
  end
  it "returns 404 if given a valid item id that doesn't exist" do 
    patch "/api/v1/items/#{Item.last.id + 1}", params: { name: 'Shiny Itemy Item',
                                                description: "It does a lot things pretty good",
                                                unit_price: 123.45,
                                                merchant_id: Merchant.first.id
                                                }

    expect(response).not_to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
  end
  it "can update with partial data too" do 
    patch "/api/v1/items/#{Item.first.id}", params: { name: 'Shiny Itemy Item',
                                                merchant_id: Merchant.first.id
                                                }

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(200)
    expect(Item.first.name).to eq('Shiny Itemy Item')
  end
  it "returns 404 if given a bad merchant id" do 
    patch "/api/v1/items/#{Item.first.id}", params: { name: 'Shiny Itemy Item',
                                                merchant_id: (Merchant.last.id + 1)
                                                }

    expect(response).not_to be_successful
    expect(response.status).to eq(404)
  end
end
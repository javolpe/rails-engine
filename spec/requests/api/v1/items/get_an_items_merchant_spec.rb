require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
    create_list(:merchant, 2)
  end
  it "retuns a merchant by id if given that param" do 
    get "/api/v1/items/#{Item.first.id}/merchant" 

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(merchant[:data].class).to eq(Hash)
    expect(merchant[:data].size).to eq(3)
    expect(merchant[:data][:attributes][:name]).to eq(Merchant.find(Item.first.merchant_id).name)    
    expect(merchant[:data][:attributes].length).to eq(1)
  end
  it "returns a 404 if given a bad item id" do 
    get "/api/v1/items/#{Item.last.id + 1}/merchant" 

    expect(response).not_to be_successful
    expect(response.status).to eq(404)
  end
end
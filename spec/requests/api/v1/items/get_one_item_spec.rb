require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
  end
  describe "E commerce Items section" do 
    it "can fetch one item" do 
      get "/api/v1/items/#{Item.first.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
    
      expect(response.status).to eq(200)
      expect(item[:data].class).to eq(Hash)
      expect(item[:data].size).to eq(3)
      expect(item[:data][:attributes].size).to eq(4)
      expect(item[:data][:id].to_i).to eq(Item.first.id)
      expect(item[:data][:attributes][:name].class).to eq(String)
      expect(item[:data][:attributes][:description].class).to eq(String)
    end
    it "returns a 404 if item id is not valid" do 
      get "/api/v1/items/#{Item.last.id + 1}"

      expect(response).not_to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
    end
    it "returns a 404 if item id is not valid" do 
      valid_id = Item.first.id
      get '/api/v1/items/valid_id'

      expect(response).not_to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
    end
  end
end
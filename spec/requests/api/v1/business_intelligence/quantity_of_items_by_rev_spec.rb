require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Items", type: :request do
  before :each do 
    seed_test_db
  end
  describe "Find a quantity of Items by descending review" do 
    it "returns 10 items if quantity param doesn't exist" do 
      get "/api/v1/revenue/items"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].length).to eq(10)
      expect(parsed[:data].first).to have_key(:id)
      expect(parsed[:data].first[:id].class).to eq(String)
      expect(parsed[:data].first[:attributes][:unit_price].class).to eq(Float)
      expect(parsed[:data].first[:attributes].class).to eq(Hash)
      expect(parsed[:data].first[:id]).to eq(@item11.id.to_s)
      expect(parsed[:data].last[:id]).to eq(@item23.id.to_s)
    end
    it "returns 10 with quantity param of 10" do
       quantity = 10
       get "/api/v1/revenue/items/?quantity=#{quantity}"
       parsed = JSON.parse(response.body, symbolize_names: true)

       expect(response).to be_successful
       expect(response.status).to eq(200)
       expect(parsed[:data].length).to eq(10)
       expect(parsed[:data].first).to have_key(:id)
       expect(parsed[:data].first[:id].class).to eq(String)
       expect(parsed[:data].first[:attributes][:unit_price].class).to eq(Float)
       expect(parsed[:data].first[:attributes].class).to eq(Hash)
       expect(parsed[:data].first[:id]).to eq(@item11.id.to_s)
       expect(parsed[:data].last[:id]).to eq(@item23.id.to_s)
    end

    it "returns the item with highest rev when the quantity is 1" do 
      quantity = 1
      get "/api/v1/revenue/items/?quantity=#{quantity}"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].length).to eq(1)
      expect(parsed[:data].first).to have_key(:id)
      expect(parsed[:data].first[:id].class).to eq(String)
      expect(parsed[:data].first[:id]).to eq(@item11.id.to_s)
    end

    it "returns all items if quantity param is too large" do 
      quantity = 10000
       get "/api/v1/revenue/items/?quantity=#{quantity}"
       parsed = JSON.parse(response.body, symbolize_names: true)

       expect(response).to be_successful
       expect(response.status).to eq(200)
       expect(parsed[:data].length).to eq(17)
       expect(parsed[:data].first).to have_key(:id)
       expect(parsed[:data].first[:id].class).to eq(String)
       expect(parsed[:data].first[:attributes][:unit_price].class).to eq(Float)
       expect(parsed[:data].first[:attributes].class).to eq(Hash)
       expect(parsed[:data].first[:id]).to eq(@item11.id.to_s)
       expect(parsed[:data].last[:id]).to eq(@item19.id.to_s)      
    end

    it "returns an error if the quantity is a string" do 
      get "/api/v1/revenue/items/?quantity=quantityisstring"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "retruns an error if the quantity is an integer below 0" do 
      quantity = -14
      get "/api/v1/revenue/items/?quantity=#{quantity}"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
    it "returns an error if the quantity param is blank" do 
      quantity = ""
      get "/api/v1/revenue/items/?quantity=#{quantity}"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
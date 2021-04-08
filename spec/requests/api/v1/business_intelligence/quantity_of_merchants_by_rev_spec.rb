require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants", type: :request do
  before :each do 
    seed_test_db
  end
  describe "Find a quantity of merchants by descending review" do 
    it "returns 10 with quantity param of 10" do
       quantity = 10
       get "/api/v1/revenue/merchants/?quantity=#{quantity}"
       parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].first).to have_key(:id)
      expect(parsed[:data].first[:id].class).to eq(String)
      expect(parsed[:data].first[:attributes].class).to eq(Hash)
      expect(parsed[:data].first[:id]).to eq(@merchant9.id.to_s)
      expect(parsed[:data].first[:attributes][:revenue].class).to eq(Float)
      expect(parsed[:data].first[:attributes][:revenue]).to eq(114.0)
      expect(parsed[:data].last[:attributes][:revenue]).to eq(5.0)
      expect(parsed[:data].size).to eq(10)
      # need to add 4 more merchants to have revenue
    end

    it "returns the merchant with highest rev when the quantity is 1" do 
      quantity = 1
      get "/api/v1/revenue/merchants/?quantity=#{quantity}"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].first).to have_key(:id)
      expect(parsed[:data].first[:id].class).to eq(String)
      expect(parsed[:data].first[:attributes].class).to eq(Hash)
      expect(parsed[:data].first[:id]).to eq(@merchant6.id.to_s)
      expect(parsed[:data].first[:attributes][:revenue].class).to eq(Float)
      expect(parsed[:data].first[:attributes][:revenue]).to eq(20770.0)
      expect(parsed[:data].size).to eq(1)
    end

    it "returns all merchants if quantity param is too large" do 
      quantity = 10000
       get "/api/v1/revenue/merchants/?quantity=#{quantity}"

      
    end

    it "returns an error if the quantity is a string" do 
      get "/api/v1/revenue/merchants/?quantity=quantityisstring"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it "retruns an error if the quantity is an integer below 0" do 
      quantity = -14
      get "/api/v1/revenue/merchants/?quantity=#{quantity}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
    it "returns an error if the quantity param is blank" do 
      quantity = ""
      get "/api/v1/revenue/merchants/?quantity=#{quantity}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
    it "returns an error if the quantity param is not provided" do 
      get "/api/v1/revenue/merchants"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
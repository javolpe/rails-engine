require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants", type: :request do
  before :each do 
    seed_test_db
  end
  describe "Potential revenue of successful invoicesthat have not yet been shipped" do
    it "returns up to 10 with no quantity param" do 
      get "/api/v1/revenue/unshipped"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].first).to have_key(:id)
      expect(parsed[:data].first[:id].class).to eq(String)
      expect(parsed[:data].first[:attributes].class).to eq(Hash)
      expect(parsed[:data].first[:id]).to eq(@invoice6.id.to_s)
      expect(parsed[:data].first[:attributes][:potential_revenue].class).to eq(Float)
      expect(parsed[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
      expect(parsed[:data].size).to eq(10)
    end
    it "returns the highest potential rev when the quantity is 1" do 
      quantity = 1
      get "/api/v1/revenue/unshipped?quantity=#{quantity}"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].first[:id]).to eq(@invoice6.id.to_s)
      expect(parsed[:data].size).to eq(1)
    end
    it "returns all invoices if quantity param is too large" do 
      quantity = 150
      get "/api/v1/revenue/unshipped?quantity=#{quantity}"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed[:data].last[:id]).to eq(@invoice9.id.to_s)
      expect(parsed[:data].size).to eq(11)
    end
    it "returns an error when the quantity is blank" do 
      quantity = ""
      get "/api/v1/revenue/unshipped?quantity=#{quantity}"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(parsed[:data]).to be_nil
    end
    it "retruns an error if the quantity is an integer below 0" do 
      quantity = -1
      get "/api/v1/revenue/unshipped?quantity=#{quantity}"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(parsed[:data]).to be_nil
    end
    it "returns an error if the quantity is a string" do 
      get "/api/v1/revenue/unshipped?quantity=#catmando"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(parsed[:data]).to be_nil
    end
  end
end
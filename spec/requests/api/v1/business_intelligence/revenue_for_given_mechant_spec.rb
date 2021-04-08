require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants", type: :request do
  before :each do 
    seed_test_db
  end
  describe "Searching for a single merchants total revenue" do
    it "returns rev for invoices that were successful and have been shipped" do 
      get "/api/v1/revenue/merchants/#{Merchant.first.id}" 

      expect(response).to be_successful
      expect(response.status).to eq(200)
      parsed = JSON.parse(response.body, symbolize_names: true)
      
      expect(parsed[:data][:id]).to eq(Merchant.first.id.to_s)
      expect(parsed[:data].length).to eq(3)
      expect(parsed[:data][:attributes][:revenue]).to eq(12.5)
      expect(parsed[:data][:attributes].length).to eq(1)
      expect(parsed[:data][:attributes]).to be_a(Hash)
      
    end
    it "returns 404 if given a bad merchant id" do 
      get "/api/v1/revenue/merchants/12341848484" 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
require 'rails_helper'

RSpec.describe "Api::V1::Merchants", type: :request do
 
  describe "E Commerce merchants section" do 
    it "sends a list of 20 merchants if no query params" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(Merchant.all.size).to eq(100)
    end
    it "returns 20 merchants as expected for page 1 results" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?page=1'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.first.name)
    end
    it "returns page 1 if page is 0 or lower" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?page=1'
      merchants_1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=0'
      merchants_0 = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants_1).to eq(merchants_0)
    end
    it "returns merchants 21-40 if page = 2" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?page=2'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
    end
    it "will return no data if fetching a page that should have no merchants" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?page=145'
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(0)
    end
    it "will return 50 if per_page=50" do
      create_list(:merchant, 100)
      get '/api/v1/merchants?per_page=50'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(50)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(merchants[:data][20][:attributes][:name]).to eq(Merchant.all[20].name)
      expect(merchants[:data][49][:attributes][:name]).to eq(Merchant.all[49].name)
    end
    it "returns all merchants if per_page is > than the amount of merchants" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?per_page=200'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(100)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(merchants[:data][20][:attributes][:name]).to eq(Merchant.all[20].name)
      expect(merchants[:data][49][:attributes][:name]).to eq(Merchant.all[49].name)
    end
    it "returns the right merchants 21-40 if page=2 and per_page=20" do 
      create_list(:merchant, 100)
      get '/api/v1/merchants?page=2&per_page=20'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(merchants[:data].class).to eq(Array)
      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].first[:attributes][:name].class).to eq(String)
      expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.limit(1).offset(20).first.name)
      expect(merchants[:data].last[:attributes][:name]).to eq(Merchant.limit(1).offset(39).first.name)
    end
    it "retuns a merchant by id if given that param" do 
      create_list(:merchant, 100)
      get "/api/v1/merchants/#{Merchant.first.id}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
  
      expect(response.status).to eq(200)
      expect(merchant[:data].class).to eq(Hash)
      expect(merchant[:data].size).to eq(3)
      expect(merchant[:data][:attributes][:name]).to eq(Merchant.first.name)    
      expect(merchant[:data][:attributes].length).to eq(1)
    end
    it "retuns a 404 id if given merchant id that doesn't exist " do 
      create_list(:merchant, 100)
      get "/api/v1/merchants/#{Merchant.last.id+1}"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
    end
    it "returns a merchants items if given a valid merchant id and /items" do 
      create_list(:merchant, 100)
      15.times do 
        create(:item, merchant_id: Merchant.first.id)
      end
      get "/api/v1/merchants/#{Merchant.first.id}/items"

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].class).to eq(Array)
      expect(items[:data].size).to eq(15)
      expect(items[:data].first[:attributes].size).to eq(4)
      expect(items[:data].first[:attributes][:merchant_id]).to eq(Merchant.first.id)    
    end
    it "returns 404 if given a bad merchant id when looking for a merchants items" do 
      create_list(:merchant, 100)
      get "/api/v1/merchants/#{Merchant.last.id + 1}/items"

      expect(response).not_to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
    end
  end
end
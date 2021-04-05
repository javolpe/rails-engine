require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
  end
  describe "E commerce Items section" do 
    it "can fetch all items" do 
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(items[:data].class).to eq(Array)
      expect(items[:data].size).to eq(20)
      expect(items[:data].first[:attributes][:name].class).to eq(String)
      expect(items[:data].first[:attributes].size).to eq(4)
      expect(Item.all.size).to eq(90)
    end
    it "fetches the first 20 for page 1" do 
      get '/api/v1/items?page=1'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(items[:data].first[:id].to_i).to eq(Item.first.id)
      expect(items[:data].last[:id].to_i).to eq(Item.offset(19).first.id)
      expect(items[:data].size).to eq(20)
    end
    it "returns page 1 if page=0 or lower" do 
      get '/api/v1/items?page=-1'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].first[:id].to_i).to eq(Item.first.id)
      expect(items[:data].last[:id].to_i).to eq(Item.offset(19).first.id)
      expect(items[:data].size).to eq(20)
    end
    it "returns page 2 if page=2" do 
      get '/api/v1/items?page=2'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].first[:id].to_i).to eq(Item.offset(20).first.id)
      expect(items[:data].last[:id].to_i).to eq(Item.offset(39).first.id)
      expect(items[:data].size).to eq(20)
    end
    it "returns 50 if per_page = 50" do 
      get '/api/v1/items?per_page=50'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].first[:id].to_i).to eq(Item.first.id)
      expect(items[:data].last[:id].to_i).to eq(Item.offset(49).first.id)
      expect(items[:data].size).to eq(50)
    end
    it "returns no data if page number is way too high" do 
      get '/api/v1/items?page=50000'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].class).to eq(Array)
      expect(items[:data].size).to eq(0)
    end
    it "retuns all items if per page is super high" do 
      get '/api/v1/items?per_page=50000'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(items[:data].class).to eq(Array)
      expect(items[:data].size).to eq(90)
    end
  end
end
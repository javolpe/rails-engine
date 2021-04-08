require 'rails_helper' 

RSpec.describe "Api::V1::Items::Search", type: :request do
  describe "Finding one Item by searching" do 
    it "for a name fragment" do 
      item1 =  create(:item, name: "Super Fancy Item Name")
      item2 =  create(:item, name: "Not Fancy Item Name")
      item3 =  create(:item, name: "Very Fancy Item Name")
      fragment = "Fancy"
      get "/api/v1/items/find?name=#{fragment}"
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to be_a(String)
      expect(json[:data][:id]).to_not eq(item1.id)
      expect(json[:data][:attributes]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
      expect(json[:data][:attributes]).to have_key(:unit_price)
      expect(json[:data][:attributes][:unit_price]).to be_a(Float)
      expect(json[:data][:attributes]).to have_key(:merchant_id)
      expect(json[:data][:attributes][:merchant_id]).to be_a(Integer)      
    end
    it "returns an empty hash for data if no name is found" do 
      item1 =  create(:item, name: "Super Fancy Item Name")
      item2 =  create(:item, name: "Not Fancy Item Name")
      item3 =  create(:item, name: "Very Fancy Item Name")
      fragment = "Fancyeageagea"
      get "/api/v1/items/find?name=#{fragment}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data]).to be_a(Hash)
      expect(json.size).to eq(1)
    end
  end
  describe 'happy path' do
    it "find one item by min price" do
      item1 = create(:item, name: "B Item", unit_price: 30.99)
      item2 = create(:item, name: "A Item", unit_price: 20.99)
      item3 = create(:item, name: "C Item", unit_price: 10.99)
      min_price = 18.99
      get "/api/v1/items/find?min_price=#{min_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data][:id]).to_not eq(item1.id.to_s)
      expect(json[:data][:id]).to eq(item2.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
    end
    it "fetches one item by max price" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      max_price = 200.00
      get "/api/v1/items/find?max_price=#{max_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data][:id]).to_not eq(item1.id.to_s)
      expect(json[:data][:id]).to eq(item2.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
    end
    it "fetches one item between min and max if both are valid" do 
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      min_price = 1.0 ; max_price = 200.00
      get "/api/v1/items/find?min_price=#{min_price}&max_price=#{max_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      expect(json.count).to eq(1)
      expect(json[:data][:id]).to_not eq(item1.id.to_s)
      expect(json[:data][:id]).to eq(item2.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
    end
    it "fetches empty data if min and max are both valid but not items match" do 
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      min_price = 1000.0 ; max_price = 2000.00
      get "/api/v1/items/find?min_price=#{min_price}&max_price=#{max_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      expect(json[:data].count).to eq(0)
      expect(json[:data]).to eq({})
    end
    it "returns 200 but no data if min price is too big" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      min_price = 1000.00
      get "/api/v1/items/find?min_price=#{min_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data].empty?).to eq(true)
    end
    it "returns 200 but no data if max price is too small" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      max_price = 1.00
      get "/api/v1/items/find?max_price=#{max_price}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data].empty?).to eq(true)
    end
  end
  describe 'sad path' do
    it "returns 400 if it sends name and min_price" do
      get "/api/v1/items/find?name=nonos&min_price=100"
      expect(response).not_to be_successful
      expect(response.status).to eq(400)
    end
    it "returns 400 if it sends name and max_price" do
      get "/api/v1/items/find?name=nonos&max_price=100"
      expect(response).not_to be_successful
      expect(response.status).to eq(400)
    end
    it "returns 400 if max_price is less than min_price" do
      get "/api/v1/items/find?min_price=100&max_price=10"
      expect(response).not_to be_successful
      expect(response.status).to eq(400)
    end
    it "returns 400 cannot have a min price below 0" do
      get "/api/v1/items/find?min_price=-1"
      expect(response).not_to be_successful
      expect(response.status).to eq(400)
    end
    it "returns 400 if max price is less than 0" do
      get "/api/v1/items/find?max_price=-1"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
    it "returns a 400 error if no query param is sent" do 
      get "/api/v1/items/find"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
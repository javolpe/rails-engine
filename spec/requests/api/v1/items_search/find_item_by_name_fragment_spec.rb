require 'rails_helper' 

RSpec.describe "Api::V1::Merchants", type: :request do
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
    it "will fail if it sends name and min_price" do 
      item1 =  create(:item, name: "Super Fancy Item Name")
      fragment = "Fancy"
      get "/api/v1/items/find?name=#{fragment}&min_price=100"
      expect(response).not_to be_successful
      
      expect(response.status).to eq(400)
    end
    it "cannot have a min price below 0" do 
      fragment = "Fancy"
      get "/api/v1/items/find?min_price=-10"
      expect(response).not_to be_successful
      
      expect(response.status).to eq(400)
    end
    it "fetches one item by max price" do 
      item1 =  create(:item, name: "Super Fancy Item Name", unit_price: 757.85)
      item2 =  create(:item, name: "Not Fancy Item Name", unit_price: 10.65)
      item3 =  create(:item, name: "Very Fancy Item Name", unit_price: 5.25)
      fragment = "Fancy"
      get "/api/v1/items/find?max_price=125"
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
    it "fetches one item by min price" do 
      item1 =  create(:item, name: "Super Fancy Item Name", unit_price: 7.85)
      item2 =  create(:item, name: "Not Fancy Item Name", unit_price: 2.65)
      item3 =  create(:item, name: "Very Fancy Item Name", unit_price: 0.25)
      fragment = "Fancy"
      get "/api/v1/items/find?min_price=1.0"
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
    it "returns 200 but no data if min price is too big" do 
      item1 =  create(:item, name: "Super Fancy Item Name", unit_price: 7.85)
      item2 =  create(:item, name: "Not Fancy Item Name", unit_price: 10.65)
      item3 =  create(:item, name: "Very Fancy Item Name", unit_price: 5.25)
      fragment = "Fancy"
      get "/api/v1/items/find?min_price=25.25"
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
    end
    it "returns 200 but no data if max price is less than 0" do 
      item1 =  create(:item, name: "Super Fancy Item Name", unit_price: 7.85)
      item2 =  create(:item, name: "Not Fancy Item Name", unit_price: 10.65)
      item3 =  create(:item, name: "Very Fancy Item Name", unit_price: 5.25)
      fragment = "Fancy"
      get "/api/v1/items/find?max_price=-25.25"
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
    end
    it "will fail if it sends name and min_price" do 
      item1 =  create(:item, name: "Super Fancy Item Name")
      fragment = "Fancy"
      get "/api/v1/items/find?name=#{fragment}&min_price=100"
      expect(response).not_to be_successful
      
      expect(response.status).to eq(400)
    end
  end
end
require 'rails_helper' 

RSpec.describe "Api::V1::Merchants", type: :request do
  describe "Finding one Item by searching name fragment" do 
    it "can find the item by a fragment of the name" do 
      item1 =  create(:item, name: "Super Fancy Item Name")
      item2 =  create(:item, name: "Not Fancy Item Name")
      item3 =  create(:item, name: "Very Fancy Item Name")
      fragment = "Fancy"
      get "/api/v1/items/find?name=#{fragment}"
      expect(response).to be_successful
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
    it "returns an empty collection for data if nothing found" do 
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
end
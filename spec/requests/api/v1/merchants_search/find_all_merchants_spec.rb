require 'rails_helper' 

RSpec.describe "Api::V1::Merchants", type: :request do
  describe "Finding all merchants that match a substring" do 
    it "finds all Merchants whose name contains the search term" do 
      merchant1 =  create(:merchant, name: "Super Mario Bros Pizza")
      merchant2 =  create(:merchant, name: "Fancy Mario Bros Plumbing")
      merchant3 =  create(:merchant, name: "Ordinary People Landscaping")
      fragment = "Bros"
      get "/api/v1/merchants/find_all?name=#{fragment}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data].first).to have_key(:id)
      expect(json[:data].first[:id]).to be_a(String)
      expect(json[:data].first[:id]).to eq(merchant2.id.to_s)
      expect(json[:data].first[:attributes]).to be_a(Hash)
      expect(json[:data].first[:attributes]).to have_key(:name)
      expect(json[:data].first[:attributes][:name]).to be_a(String)
      expect(json[:data].second[:attributes][:name]).to eq(merchant1.name)
      expect(json[:data].second[:id]).to eq(merchant1.id.to_s)
    end
    it "returns an empty hash for data if no name is found to match the substring" do 
      merchant1 =  create(:merchant, name: "Super Mario Bros Pizza")
      merchant2 =  create(:merchant, name: "Fancy Mario Bros Plumbing")
      merchant3 =  create(:merchant, name: "Ordinary People Landscaping")
      fragment = "Fancyeageagea"
      get "/api/v1/merchants/find_all?name=#{fragment}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data]).to be_an(Array)
      expect(json.size).to eq(1)
      expect(json[:data].empty?).to eq(true)
    end
  end
end
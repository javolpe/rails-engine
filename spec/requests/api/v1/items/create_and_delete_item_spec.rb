require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  before :each do 
    create_list(:item, 90)
  end
  
  it "can create one item" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    unit_price: 123.45,
                                    merchant_id: Merchant.first.id
                                    }
    
    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
  
    expect(response.status).to eq(201)
    expect(Item.all.size).to eq(91)
    expect(Item.last.name).to eq('Shiny Itemy Item')
  end
  it "can not create an item if any attribute is missing" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    merchant_id: Merchant.first.id
                                    }
    
    expect(response).not_to be_successful
    expect(response.status).to eq(404)
  end
  it "can not create an item if there are extra attributes" do 
    expect(Item.all.size).to eq(90)
    post "/api/v1/items", params: { name: 'Shiny Itemy Item',
                                    description: "It does a lot things pretty good",
                                    unit_price: 123.45,
                                    merchant_id: Merchant.first.id,
                                    something: "extra"
                                    }
    
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(Item.all.size).to eq(91)
    expect(Item.last.name).to eq('Shiny Itemy Item')
  end
  it "can delete one item" do 
    expect(Item.all.size).to eq(90)
    delete "/api/v1/items/#{Item.first.id}"
    expect(response).to be_successful
  
    expect(response.status).to eq(204)
    expect(Item.all.size).to eq(89)
  end
  it "deletes an invoice if there was only item on the invoice" do 
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_3 = create(:invoice)
    invoice_4 = create(:invoice)
    
    item_1 = Item.first
    item_2 = Item.second
    item_3 = Item.third
    
    invoice_1.items << item_1

    invoice_2.items << item_1
    invoice_2.items << item_2

    invoice_3.items << item_1
    invoice_3.items << item_3

    invoice_4.items << item_1

    delete "/api/v1/items/#{Item.first.id}"
    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect{ Item.find(item_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect{ Invoice.find(invoice_1.id) }.to raise_error(ActiveRecord::RecordNotFound)      
    expect(Invoice.find(invoice_2.id)).to eq(invoice_2)
    expect(Invoice.find(invoice_3.id)).to eq(invoice_3)
    expect{ Invoice.find(invoice_4.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
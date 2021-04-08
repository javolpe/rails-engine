require 'rails_helper'

RSpec.describe Item, type: :model do
  before :each do 
    seed_test_db
  end
  describe "relationships" do
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  describe "Class methods" do 
    it "finds items by name fragment and sorts alphabetically" do 
      term = "ano"
      result = Item.find_one_by_name_fragment(term)

      expect(result).to be_a(Item)
      expect(result.name).to eq("another item")
      expect(result).to eq(@item3)
    end
    it "can find an item by MAX price sorted alphabetically" do 
      max = 25
      result = Item.find_by_max_price(max)

      expect(result).to be_a(Item)
      expect(result.name).to eq("Item 10")
      expect(result).to eq(@item10)
    end

    it "can find an item by MIN price sorted alphabetically" do 
      max = 5
      result = Item.find_by_min_price(max)

      expect(result).to be_a(Item)
      expect(result.name).to eq("Item 7")
      expect(result).to eq(@item7)
    end

    it "can find quantity of items sorted by revenue" do 
      quantity = 5
      result = Item.sorted_by_revenue(quantity)

      expect(result.length).to eq(5)
      expect(result.first.name).to eq("Item 11")
      expect(result.first).to eq(@item11)
      expect(result.last.name).to eq("Item 10")
      expect(result.last).to eq(@item10)
    end
    it "can find all items with revenue if quantity of items sorted by revenue is large enough" do 
      quantity = 500000
      result = Item.sorted_by_revenue(quantity)

      expect(result.length).to eq(17)
      expect(result.first.name).to eq("Item 11")
      expect(result.first).to eq(@item11)
    end
  end
end
require 'rails_helper'

describe Merchant do
  before :each do 
    seed_test_db
  end
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it {should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end
  describe "Class Methods" do 
    it "can find all merchants by name fragment" do 
      fragment = "1"
      result = Merchant.find_all_by_name_fragment(fragment)

      expect(result.length).to eq(5)
      expect(result.first).to eq(@merchant1)
      expect(result.last).to eq(@merchant13)
    end

    it "can find a quantity merchants sorted by most revenue" do 
      quantity = 5
      result = Merchant.sorted_by_revenue(quantity)

      expect(result.length).to eq(5)
      expect(result.first).to eq(@merchant9)
      expect(result.last).to eq(@merchant12)
    end
    it "can find a different quantity merchants sorted by most revenue" do 
      quantity = 10
      result = Merchant.sorted_by_revenue(quantity)
      
      expect(result.length).to eq(10)
      expect(result.first).to eq(@merchant9)
      expect(result.last).to eq(@merchant6)
    end
  end
  describe "Instance Methods" do 
    it "can find the revenue for a given mercant" do 
      @merchant = Merchant.first 
      result = @merchant.revenue_for_one_merchant

      expect(result).to eq(12.5)
    end
    it "can find the revenue of a different mercant" do 
      @merchant = Merchant.third 
      result = @merchant.revenue_for_one_merchant

      expect(result).to eq(10.5)
    end
  end
end
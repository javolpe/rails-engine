require 'rails_helper'

RSpec.describe "Api::V1::Revenue::Merchants", type: :request do
  before :each do 
    seed_test_db
  end
  describe "Find a quantity of merchants by descending review" do 
    it "returns up to 10 with no quantity param" do 

    end
    it "returns the highest potential rev when the quantity is 1" do 

    end

  end
  it "returns all invoices if quantity param is too large" do 

  end
  it "returns an error when the quantity is blank" do 

  end
  it "retruns an error if the quantity is an integer below 0" do 

  end
  it "returns an error if the quantity is a string" do 
    
  end
end
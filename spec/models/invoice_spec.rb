require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before :each do 
    seed_test_db
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe 'class methods' do 
    describe '::unshipped reveneue' do 
      it 'returns the revenue of unshipped items for quantity of 10' do 
        result = Invoice.unshipped_revenue(10)
        
        expect(result.first.id).to eq(@invoice6.id)
        expect(result.first.potential_revenue).to eq(20770.0)
        expect(result.last.id).to eq(@invoice14.id)
        expect(result.last.potential_revenue).to eq(120.0)
        expect(result[10]).to be_nil
        expect(result.pluck(:id).size).to eq(10)
      end
      it 'returns one item if given quanity of one' do 
        result = Invoice.unshipped_revenue(1)
        
        expect(result.first.id).to eq(@invoice6.id)
        expect(result.first.potential_revenue).to eq(20770.0)
        expect(result.second).to be_nil
      end
    end
  end
end
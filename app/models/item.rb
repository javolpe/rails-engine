class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
  has_many :discounts, through: :merchant
  
  validates_presence_of [:name, :description, :unit_price, :merchant_id], on: :create

  def self.find_one_by_name_fragment(search_term)
    where('lower(name) LIKE ?', '%' + search_term + '%')
    .order(:name)
    .limit(1)
    .first
  end
end
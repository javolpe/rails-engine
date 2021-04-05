class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
  has_many :discounts, through: :merchant
  
  validates_presence_of [:name, :description, :unit_price, :merchant_id], on: :create
end
class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_one :customer, through: :invoice 
  has_one :merchant, through: :item
end
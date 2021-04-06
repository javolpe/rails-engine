class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :discounts

  def self.find_all_by_name_fragment(search_term)
    where('lower(name) LIKE ?', '%' + search_term + '%')
    .order(:name)

  end
end
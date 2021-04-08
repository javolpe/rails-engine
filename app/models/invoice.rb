class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  

  def self.unshipped_revenue(quantity)
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
    .joins(:invoice_items)
    .where('invoices.status = ?', 'packaged')
    .group('invoices.id')
    .order('potential_revenue desc')
    .limit(quantity)
  end
end


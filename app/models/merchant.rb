class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  

  def self.find_all_by_name_fragment(search_term)
    where('name ILIKE ?', '%' + search_term + '%')
    .order(:name)
  end

  def revenue_for_one_merchant
    transactions
    .where("invoices.status = 'shipped'")
    .where("transactions.result = 'success'")
    .pluck("(invoice_items.quantity * items.unit_price) AS revenue")
    .sum.round(2)
  end

  # def revenue_for_one_merchant
  #   transactions
  #   .where('invoices.status = ?', 'shipped')
  #   .where('transactions.result = ?', 'success')
  #   .pluck("(invoice_items.quantity * items.unit_price) AS revenue")
  #   .sum.round(2)
  # end

  def self.sorted_by_revenue(quantity)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions)
    .where("transactions.result = 'success'")
    .where("invoices.status = 'shipped'")
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end
end
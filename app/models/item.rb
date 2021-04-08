class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  
  validates_presence_of [:name, :description, :unit_price, :merchant_id], on: :create

  def self.find_one_by_name_fragment(search_term)
    where('lower(name) LIKE ?', '%' + search_term + '%' )
    .order(:name)
    .limit(1)
    .first
  end

  # def self.find_one_by_name_fragment(search_term)
  #   where("lower(name) LIKE ? or lower(description) LIKE ?", "%#{search_term}%", "%#{search_term}%")
  #   .order(:name)
  #   .limit(1)
  #   .first
  # end

  def self.find_by_max_price(max_price)
    where("unit_price < ?", max_price)
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_by_min_price(min_price)
    where("unit_price > ?", min_price)
    .order(:name)
    .limit(1)
    .first
  end

  def self.sorted_by_revenue(quantity)
    select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions).where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end
end
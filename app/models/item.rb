class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
  has_many :discounts, through: :merchant
  
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
end
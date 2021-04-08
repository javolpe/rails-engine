class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :revenue do |merchant|
    merchant.revenue.to_f
  end
end

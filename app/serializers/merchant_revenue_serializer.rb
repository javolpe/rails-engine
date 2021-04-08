class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  

  attributes :revenue do |merchant|
    merchant.revenue_for_one_merchant
  end
end

FactoryBot.define do
  factory :invoice_item do
    item 
    invoice 
    quantity { Faker::Number(digits: 1)}
    unit_price { Faker::Number(l_digits: 2, r_digits: 2)}
  end
end
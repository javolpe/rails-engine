FactoryBot.define do
  factory :transaction do
    invoice 
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { "12/23" }
    result { "success" }
  end
end
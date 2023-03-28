FactoryBot.define do
  factory :item do
    name { Faker::Name.first_name}
    description { Faker::ChuckNorris.fact }
    unit_price {Faker::Number.decimal(l_digits: 2)}
    # merchant_id {Faker::Number.number(digits: 1..2)}
  end
end
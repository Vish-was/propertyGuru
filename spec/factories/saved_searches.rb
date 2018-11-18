FactoryBot.define do
  factory :saved_search do
    user_id nil
    name { Faker::TwinPeaks.location }
    description { Faker::TwinPeaks.quote }
    criteria {{
      "minimum_price": Faker::Number.decimal(5,2),
      "maximum_price": Faker::Number.decimal(6,2),
      "attractions": [
        Faker::Number.between(1,100),
        Faker::Number.between(1,10)
      ],
      "downtown_importance": Faker::Number.between(0,2)*50,
      "minimum_bedrooms": Faker::Number.between(1,5)
    }}
  end
end

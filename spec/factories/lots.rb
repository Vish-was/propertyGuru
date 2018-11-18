FactoryBot.define do
  factory :lot do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    information { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(5,0) }
    sqft { Faker::Number.between(4000,200000) }
    community_id nil
    name Faker::Name.name
    location Faker::TwinPeaks.location
  end
end

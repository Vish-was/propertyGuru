FactoryBot.define do
  factory :collection do
    name { Faker::Company.name }
    information { Faker::Lorem.paragraph }
    region_id nil
  end
end

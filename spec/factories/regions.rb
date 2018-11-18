FactoryBot.define do
  factory :region do
    name { Faker::Space.galaxy }
    builder_id nil
  end
end

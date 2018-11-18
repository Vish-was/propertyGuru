FactoryBot.define do
  factory :community do
    name Faker::Name.name
    location Faker::TwinPeaks.location
    division_id nil
  end
end

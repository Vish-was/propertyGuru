FactoryBot.define do
  factory :community do
    name Faker::Name.name
    location Faker::TwinPeaks.location
    division_id nil
    image_file_name { Faker::File.file_name }
    image_content_type { "image/jpeg" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
    information { Faker::Lorem.sentence }
  end
end

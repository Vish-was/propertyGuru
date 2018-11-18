FactoryBot.define do
  factory :plan_room do
    name { Faker::Name.name }
    image_file_name { Faker::File.file_name }
    image_content_type { "image/jpeg" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
    type { Faker::Lorem.word }
  end
end

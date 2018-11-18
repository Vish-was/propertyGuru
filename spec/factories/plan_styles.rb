FactoryBot.define do
  factory :plan_style do
    name { Faker::Team.mascot }
    image_file_name { Faker::File.file_name }
    image_content_type { "image/png" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
  end
end

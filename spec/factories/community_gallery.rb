FactoryBot.define do
 factory :community_gallery do
    image_file_name { Faker::File.file_name }
    image_content_type { "image/jpeg" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
    community_id nil
  end
end
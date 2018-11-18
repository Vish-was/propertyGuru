FactoryBot.define do
  factory :plan_image do
    story { Faker::Number.between(1,3) }
    base_image_file_name { Faker::File.file_name }
    base_image_content_type { "image/jpeg" }
    base_image_file_size { Faker::Number.between(10000,500000) }
    base_image_updated_at { DateTime.now }
    # base_image { File.new("#{Rails.root}/coverage/assets/0.10.2/magnify.png") }
    plan_id nil
  end
end

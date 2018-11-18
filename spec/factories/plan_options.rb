FactoryBot.define do
  factory :plan_option do
    name { Faker::Space.galaxy }
    information { Faker::Lorem.sentence }
    default_price { Faker::Number.decimal(5,2) }
    category { Faker::Lorem.word }
    sqft_ac { Faker::Number.between(10,1000) }
    thumbnail_image_file_name { Faker::File.file_name }
    thumbnail_image_content_type { "image/png" }
    thumbnail_image_file_size { Faker::Number.between(10000,500000) }
    thumbnail_image_updated_at { DateTime.now }
    plan_image_file_name { Faker::File.file_name }
    plan_image_content_type { "image/png" }
    plan_image_file_size { Faker::Number.between(10000,500000) }
    plan_image_updated_at { DateTime.now }
    pano_image { Faker::Internet.url }
    vr_parameter{Faker::Lorem.sentence}
    type { Faker::Lorem.word }
    sqft_living { Faker::Number.between(400,20000)}
    sqft_porch { Faker::Number.between(400,20000)}
    sqft_patio { Faker::Number.between(400,20000)}
    width { Faker::Number.between(10,10000)}
    depth { Faker::Number.between(10,10000)}
    plan_option_set_id nil
  end
end

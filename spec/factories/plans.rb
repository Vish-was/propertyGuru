FactoryBot.define do
  factory :plan do
    name { Faker::Space.galaxy }
    information { Faker::Lorem.paragraphs }
    min_price { Faker::Number.decimal(6,2) }
    min_sqft { Faker::Number.between(400,20000) }
    min_bedrooms { (Faker::Number.between(2,14))/2 }
    min_bathrooms { (Faker::Number.between(1,10))/2 }
    min_garage { (Faker::Number.between(2,10))/2  }
    max_price { Faker::Number.decimal(6,2) }
    max_sqft { Faker::Number.between(400,20000) }
    max_bedrooms { (Faker::Number.between(2,14))/2 }
    max_bathrooms { (Faker::Number.between(1,10))/2 }
    max_garage { (Faker::Number.between(2,10))/2  }
    image_file_name { Faker::File.file_name }
    image_content_type { "image/png" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
    min_stories { Faker::Number.between(1,4) }
    max_stories { Faker::Number.between(4,8) }
    collection_id nil
  end
end

FactoryBot.define do
  factory :builder do
    name { Faker::Company.name }
    production { Faker::Company.name }
    website { Faker::Lorem.paragraph }
    logo_file_name { Faker::File.file_name }
    logo_content_type { "image/jpeg" }
    logo_file_size { Faker::Number.between(10000,500000) }
    logo_updated_at { DateTime.now }
    about { Faker::Lorem.paragraph }
    locations { Faker::TwinPeaks.location }
  end
end

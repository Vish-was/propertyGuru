FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number } 
    email { Faker::Internet.email }
    title { Faker::Job.title }
    builder_default false
    division_id nil
    builder_id nil
  end
end

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { DateTime.now }
    current_sign_in_at { Faker::Date.between(2.years.ago, Date.today) }
    image_file_name { Faker::File.file_name }
    image_content_type { "image/png" }
    image_file_size { Faker::Number.between(10000,500000) }
    image_updated_at { DateTime.now }
    profile {{
      "_id": "5ab984d76dea11c58c10e3d3",
      "tags": [
        "duis",
        "velit",
        "occaecat",
        "est",
        "sint",
        "sit",
        "ut"
      ],
      "friends": [{
          "id": 0,
          "name": "Teri Robinson"
        },
        {
          "id": 1,
          "name": "Pamela Olsen"
        },
        {
          "id": 2,
          "name": "Reid Small"
        }
      ],
      "greeting": "Hello, Elma Walker! You have 5 unread messages."
    }}
  end
end

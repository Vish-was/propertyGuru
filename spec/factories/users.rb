FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { DateTime.now }
    current_sign_in_at { Faker::Date.between(2.years.ago, Date.today) }
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

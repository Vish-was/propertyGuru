FactoryBot.define do
  factory :saved_plan do
    plan_id nil
    user_id nil
    name { Faker::Space.galaxy }
    description { Faker::ChuckNorris.fact }
  end
end

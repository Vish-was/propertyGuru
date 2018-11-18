FactoryBot.define do
  factory :communities_plan do

    base_price { Faker::Number.decimal(5, 2) }
    community_id nil
    plan_id nil
  end
end

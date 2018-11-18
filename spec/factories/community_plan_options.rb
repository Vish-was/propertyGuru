FactoryBot.define do
  factory :community_plan_option do
    base_price Faker::Number.decimal(5, 2)
    community_id nil
    plan_option_id nil
  end
end
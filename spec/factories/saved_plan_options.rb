FactoryBot.define do
  factory :saved_plan_option do
    saved_plan_id nil
    plan_option_id nil
    plan_option_set_id nil
    quoted_price Faker::Number.decimal(5, 2)
  end
end

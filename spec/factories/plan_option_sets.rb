FactoryBot.define do
  factory :plan_option_set do
    name { Faker::Space.galaxy }
    story { Faker::Number.between(1,3) }
    position_2d_x {Faker::Number.decimal(6,2)}
    position_2d_y { Faker::Number.decimal(6,2) }
    plan_id nil
    default_plan_option_id nil
  end
end
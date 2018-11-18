FactoryBot.define do
  factory :vr_scene do
    plan_id nil
    name { Faker::Beer.name }
  end
end

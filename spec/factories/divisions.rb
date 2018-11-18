FactoryBot.define do
  factory :division do
    name { Faker::DrWho.specie }
    region_id nil
  end
end

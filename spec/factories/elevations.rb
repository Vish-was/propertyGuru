FactoryBot.define do
  factory :elevation do
    name { Faker::HitchhikersGuideToTheGalaxy.location }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(5, 2) }
    #image { File.new("#{Rails.root}/coverage/assets/0.10.2/magnify.png") }
    plan_id nil
  end
end

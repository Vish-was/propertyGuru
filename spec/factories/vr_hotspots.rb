FactoryBot.define do
  factory :vr_hotspot do
    plan_option_set_id nil
    vr_scene_id nil
    jump_scene_id nil
    toggle_default true
    name { Faker::Beer.name }
    type "menu" 
    toggle_method { Faker::Lorem.word }
    show_on_plan_option_id nil
    hide_on_plan_option_id nil
  end
end

json.(@saved_plan, :quoted_price, :name, :description, :is_favorite, :is_public)

json.user_name @saved_plan.user.name if @saved_plan.user
json.elevation_name @saved_plan.elevation.name if @saved_plan.elevation.present?
json.contact_name @saved_plan.contact.name if @saved_plan.contact.present?
json.saved_plan_options @saved_plan.saved_plan_options do |saved_plan_option|
  json.(saved_plan_option, :quoted_price, :plan_option_set_id, :plan_option_id)
end

if @saved_plan.plan
  json.plan_name @saved_plan.plan.name
  json.plan_image @saved_plan.plan.image.expiring_url(10)

  json.vr_images @saved_plan.vr_scene_images do |vr_scene|
    json.(vr_scene, :vr_scene_id, :vr_scene_image)
  end
end

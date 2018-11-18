json.tour do
  json.(@plan, :id, :name, :min_price, :min_sqft, :max_sqft, :min_bedrooms, :max_bedrooms, :min_bathrooms, :max_bathrooms, :min_garage, :max_garage, :min_stories, :max_stories)
  json.image @plan.image.expiring_url(10)
  json.scenes @plan.vr_scenes do |vr_scene|
    json.(vr_scene, :id, :name, :initial_scene_image)
    json.hotspots vr_scene.vr_hotspots do |vr_hotspot|
      json.(vr_hotspot, :id, :name, :position, :rotation, :jump_scene_id, :jump_scene_id, :type, :toggle_default, :jump_scene_id,:toggle_method, :show_on_plan_option_id, :hide_on_plan_option_id)
      if vr_hotspot.plan_option_set.present?
        json.plan_option_set do
          json.(vr_hotspot.plan_option_set, :id, :name, :default_plan_option_id)
          json.options vr_hotspot.plan_option_set.plan_options do |plan_option|
            json.(plan_option, :id, :name, :price_total, :price_monthly)
            json.thumbnail_image plan_option.thumbnail_image.expiring_url(10)
          end
        end
      end
      show_plan_option = PlanOption.find_by_id(vr_hotspot.show_on_plan_option_id)
      hide_plan_option = PlanOption.find_by_id(vr_hotspot.hide_on_plan_option_id)            
      json.show_on_plan_option_set_id show_plan_option.plan_option_set.id if show_plan_option.present?
      json.hide_on_plan_option_set_id hide_plan_option.plan_option_set.id if hide_plan_option.present?      
    end
  end
end

json.partial! 'paged/paged'
json.results @paged[:results] do |vr_hotspot|
  json.(vr_hotspot, :id, :name, :plan_option_set_id, :position, :rotation, :type, :toggle_default, :jump_scene_id,:toggle_method, :show_on_plan_option_id, :hide_on_plan_option_id)
end
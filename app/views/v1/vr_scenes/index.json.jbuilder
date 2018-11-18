json.partial! 'paged/paged'
json.results @paged[:results] do |vr_scene|
  json.(vr_scene, :id, :name, :plan_id, :initial_scene_image)
end
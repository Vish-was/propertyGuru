json.partial! 'paged/paged'
json.results @paged[:results] do |plan_option_set|
  json.(plan_option_set, :id, :name, :position_2d_x, :position_2d_y, :default_plan_option_id, :story)
end

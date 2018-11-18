json.partial! 'paged/paged'
json.results @paged[:results] do |saved_plan_option|
  json.(saved_plan_option, :id, :id, :saved_plan_id, :plan_option_set_id,  :plan_option_id, :quoted_price)
end
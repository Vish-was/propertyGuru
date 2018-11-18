json.partial! 'paged/paged'
json.results @paged[:results] do |saved_plan|
  json.(saved_plan, :id, :plan_id, :elevation_id, :name, :description, :quoted_price)
  json.plan_name saved_plan.plan.name if saved_plan.plan
  json.plan_image saved_plan.plan.image.expiring_url(10) if saved_plan.plan
end
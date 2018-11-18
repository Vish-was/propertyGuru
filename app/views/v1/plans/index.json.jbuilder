json.partial! 'paged/paged'
json.results @paged[:results] do |plan|
  json.(plan, :id, :name, :min_price)
  json.image plan.image.expiring_url(10)
  json.community_base_prices plan.communities_plans do |community_plan|
    json.(community_plan, :community_id,  :base_price)
    json.name community_plan.community.name
  end
  json.lot_boxes [
    {"west": "-97.786105", "south": "30.26609", "east": "-97.747110", "north": "30.328107"},
    {"west": "-97.664399", "south": "30.260019", "east": "-97.636693", "north": "30.284917"},
    {"west": "-98.360805", "south": "29.418630", "east": "-98.215958", "north": "29.538635"}
  ]
end

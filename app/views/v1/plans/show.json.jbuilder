json.(@plan, :id, :name, :min_price, :min_sqft, :max_sqft, :min_bedrooms, :max_bedrooms, :min_bathrooms, :max_bathrooms, :min_garage, :max_garage, :min_stories, :max_stories)
json.image @plan.image.expiring_url(10)

json.elevations @plan.elevations do |elevation|
  json.(elevation, :description, :id, :name, :price)
  json.image elevation.image.expiring_url(10)
end

json.stories 1..@plan.min_stories.to_i do |story|
  json.story story
  json.plan_options @plan.plan_options do |option|
    json.(option, :id, :name, :default_price, :information, :pano_image)
    json.plan_image option.plan_image.expiring_url(1800)
    json.thumbnail_image option.thumbnail_image.expiring_url(10)    
  end
  
  json.plan_option_set @plan.plan_option_sets do |option_set|
    json.(option_set,:id, :name, :default_plan_option_id, :position_2d_x, :position_2d_y, :story)
    json.plan_option option_set.plan_options do |option|
      json.(option, :id, :name, :default_price, :information, :pano_image)
      json.plan_image option.plan_image.expiring_url(1800)
      json.thumbnail_image option.thumbnail_image.expiring_url(10)
    end
  end
  json.base_image @plan.plan_images.story(story).first.base_image.expiring_url(10) if @plan.plan_images.where(story: story).first.present?
end

json.lot_boxes [
    {"west": "-97.786105", "south": "30.26609", "east": "-97.747110", "north": "30.328107"},
    {"west": "-97.664399", "south": "30.260019", "east": "-97.636693", "north": "30.284917"},
    {"west": "-98.360805", "south": "29.418630", "east": "-98.215958", "north": "29.538635"}
]
json.partial! 'paged/paged'
json.results @paged[:results] do |plan_option|
  json.(plan_option, :id, :name, :default_price, :information, :pano_image)
  json.thumbnail_image plan_option.thumbnail_image.expiring_url(10)
  json.plan_image plan_option.plan_image.expiring_url(10)
end

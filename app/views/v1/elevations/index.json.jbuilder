json.partial! 'paged/paged'
json.results @paged[:results] do |elevation|
  json.(elevation, :id, :name, :price)
  json.image elevation.image.expiring_url(10)
end
json.partial! 'paged/paged'
json.results @paged[:results] do |amenity|
  json.(amenity, :id, :name)
end
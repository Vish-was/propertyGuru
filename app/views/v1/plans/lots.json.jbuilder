json.partial! 'paged/paged'
json.results @paged[:results] do |lot|
  json.(lot, :id, :latitude, :longitude, :price)
end
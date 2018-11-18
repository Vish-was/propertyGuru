json.partial! 'paged/paged'
json.results @paged[:results].pluck(:type).uniq do |type|
  json.type type
  json.rooms @paged[:results].where(type: type) do |room|
    json.(room, :id, :name)
    json.image room.image.expiring_url(10)
  end  
end  
  

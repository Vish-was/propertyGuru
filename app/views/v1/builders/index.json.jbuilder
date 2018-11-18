json.partial! 'paged/paged'
json.results @paged[:results] do |builder|
  json.(builder, :id, :name)
end
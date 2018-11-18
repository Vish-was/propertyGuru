json.partial! 'paged/paged'
json.results @paged[:results] do |collection|
  json.(collection, :id, :name)
end

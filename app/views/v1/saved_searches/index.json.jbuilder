json.partial! 'paged/paged'
json.results @paged[:results] do |saved_search|
  json.(saved_search, :id, :name, :description)
  json.criteria saved_search.criteria
end

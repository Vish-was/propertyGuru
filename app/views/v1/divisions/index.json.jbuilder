json.partial! 'paged/paged'
json.results @paged[:results] do |division|
  json.(division, :id, :name)
end

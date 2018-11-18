json.partial! 'paged/paged'
json.results @paged[:results] do |community|
  json.(community, :id, :name)
end
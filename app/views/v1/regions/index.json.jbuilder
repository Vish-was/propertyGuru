json.partial! 'paged/paged'
json.results @paged[:results] do |regions|
  json.(regions, :id, :name)
end


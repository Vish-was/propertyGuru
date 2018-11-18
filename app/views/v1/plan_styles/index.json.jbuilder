json.partial! 'paged/paged'
json.results @paged[:results] do |style|
  json.(style, :id, :name)
  json.image style.image.expiring_url(10)
end

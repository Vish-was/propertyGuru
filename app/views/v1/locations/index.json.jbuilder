json.count @locations.count
#json.page @page
json.results @locations do |location|
  json.location location
end

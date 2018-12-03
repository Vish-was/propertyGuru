json.partial! 'paged/paged'
json.results @paged[:results] do |community_gallery|
  json.(community_gallery, :id)
  json.image community_gallery.image.expiring_url(10)
end	
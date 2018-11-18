json.partial! 'paged/paged'
json.results @paged[:results] do |user|
  json.(user, :id, :name, :email)
end

json.partial! 'paged/paged'
json.results @paged[:results] do |contact|
  json.(contact, :id, :name, :email, :phone, :title, :division_name, :builder_default)
end

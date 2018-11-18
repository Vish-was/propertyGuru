json.(@plan_option, :name, :default_price, :information, :sqft_ac, :pano_image, :vr_parameter, :type, :sqft_living, :sqft_porch, :sqft_patio, :width, :depth)
json.thumbnail_image @plan_option.thumbnail_image.expiring_url(10)
json.plan_image @plan_option.plan_image.expiring_url(10)

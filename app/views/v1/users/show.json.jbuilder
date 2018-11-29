json.(@user, :name, :email, :profile)
json.image @user.image.expiring_url(10)


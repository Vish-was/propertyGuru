Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,      ENV['OAUTH_FACEBOOK_KEY'], ENV['OAUTH_FACEBOOK_SECRET'], 
    {
      redirect_uri: 'https://api.myhouseby.com/omniauth/facebook/callback'
    }
  provider :google_oauth2, ENV['OAUTH_GOOGLE_KEY'],   ENV['OAUTH_GOOGLE_SECRET'],
    {
      redirect_uri: 'https://api.myhouseby.com/omniauth/google_oauth2/callback'
    }
end
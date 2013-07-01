OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    
  provider :twitter, CONFIG[:omniauth][:twitter][:key], CONFIG[:omniauth][:twitter][:secret]
  
  provider :facebook, CONFIG[:omniauth][:facebook][:id], CONFIG[:omniauth][:facebook][:secret]

  provider :google_oauth2, CONFIG[:omniauth][:google_oauth2][:key], CONFIG[:omniauth][:google_oauth2][:secret]

end
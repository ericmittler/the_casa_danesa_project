OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    
  provider :twitter, CONFIG[:omniauth][:twitter][:key], CONFIG[:omniauth][:twitter][:secret]
  
  provider :identity, on_failed_registration: lambda { |env|
    IdentitiesController.action(:new).call(env)
  }
end
module AuthHelper
    def auth_headers(user)
      token = Doorkeeper::AccessToken.create!(
        resource_owner_id: user.id,
        application_id: nil,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        scopes: ''
      )
      
      { 'Authorization' => "Bearer #{token.token}" }
    end
  end
  
  RSpec.configure do |config|
    config.include AuthHelper, type: :request
  end

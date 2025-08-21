# frozen_string_literal: true

Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record
  grant_flows %w[client_credentials password authorization_code refresh_token]

  access_token_expires_in 2.hour
  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_from_credentials do |_routes|
    user = User.find_by(email: params[:username])
    user if user&.valid_password?(params[:password])
  end

  use_refresh_token

  admin_authenticator do |_routes|
    current_user || warden.authenticate!(scope: :user)
  end

  skip_authorization do
    true
  end
end

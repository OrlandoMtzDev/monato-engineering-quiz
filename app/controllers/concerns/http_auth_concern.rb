module HttpAuthConcern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  def http_authenticate
    authenticate_or_request_with_http_basic(nil, message) do |username, password|
      username == Figaro.env.HTTP_BASIC_AUTH_USER && password == Figaro.env.HTTP_BASIC_AUTH_PASSWORD
    end
  end

  def message
    { errors: ['Invalid authorization'] }.to_json
  end
end

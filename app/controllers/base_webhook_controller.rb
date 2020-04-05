class BaseWebhookController < ApiController
  # all incoming webhooks need to pass through this controller

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_api_key

  protected

  def authenticate_api_key
    authenticate_with_http_token do |token, _options|
      raise ForbiddenError, "Token Missing!" if token.blank?
      @current_api_client = ApiClient.find_by(api_key: token)
    end

    raise ForbiddenError, "Please provide a valid token!" if @current_api_client.blank?

    raise AuthenticationError, "API Key Expired!" if @current_api_client.api_key_expired?
  end
end

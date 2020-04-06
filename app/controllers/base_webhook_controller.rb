class BaseWebhookController < ApiController
  # all incoming webhooks need to pass through this controller

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_api_key
  before_action :set_raven_context

  private

  def authenticate_api_key
    raise ForbiddenError, "Please provide Auth Headers!" if request.headers["Authorization"].blank?

    authenticate_with_http_token do |token, _options|
      @current_api_client = ApiClient.find_by(api_key: token)
    end

    raise ForbiddenError, "Please provide a valid token!" if @current_api_client.blank?
    raise AuthenticationError, "API Key Expired!" if @current_api_client.api_key_expired?
  end

  def set_raven_context
    Raven.user_context(id: @current_api_client.id) if @current_api_client.present?
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end

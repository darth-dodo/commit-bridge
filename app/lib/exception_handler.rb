module ExceptionHandler
  extend ActiveSupport::Concern
  class AuthenticationError < StandardError; end

  class CommitBridgeValidationError < StandardError
    attr_reader :message
    def initialize(message = nil)
      @message = message || Message.default_error_message
    end
  end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::CommitBridgeValidationError, with: :four_zero_zero
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
  end

  private

  def record_not_found
    json_response({ error_message: Message.not_found }, :not_found)
  end

  def four_twenty_two(e)
    json_response({ error_message: e.message }, :unprocessable_entity)
  end

  def four_zero_zero(e)
    json_response({ error_message: e.message }, :bad_request)
  end

  def unauthorized_request(e)
    json_response({ error_message: e.message }, :unauthorized)
  end
end

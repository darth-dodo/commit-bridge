module CommitBridgeExceptions
  class CommitBridgeBaseException < StandardError; end
  class AuthenticationError < CommitBridgeBaseException; end
  class ForbiddenError < CommitBridgeBaseException; end

  class ExternalApiException < CommitBridgeBaseException
    attr_reader :status_code, :response

    def initialize(status_code, response)
      @status_code = status_code
      @response = response
    end
  end

  class CommitBridgeValidationError < CommitBridgeBaseException
    attr_reader :message
    def initialize(message = nil)
      @message = message || Message.default_error_message
    end
  end
end

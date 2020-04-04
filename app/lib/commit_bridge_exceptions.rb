module CommitBridgeExceptions
  class CommitBridgeBaseException < StandardError; end
  class AuthenticationError < CommitBridgeBaseException; end
  class ExternalApiException < CommitBridgeBaseException; end

  class CommitBridgeValidationError < CommitBridgeBaseException
    attr_reader :message
    def initialize(message = nil)
      @message = message || Message.default_error_message
    end
  end
end

module ExternalExceptions
  include CommitBridgeExceptions

  BadRequestError = Class.new(ExternalApiException)
  UnauthorizedError = Class.new(ExternalApiException)
  ForbiddenError = Class.new(ExternalApiException)
  NotFoundError = Class.new(ExternalApiException)
  UnprocessableEntityError = Class.new(ExternalApiException)
  GenericApiError = Class.new(ExternalApiException)
end

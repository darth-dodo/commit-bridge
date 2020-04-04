module TicketTrackingCommunicator
  include HttpStatusCodes
  include ExternalExceptions

  TICKET_TRACKING_API_ROOT = ENV["TICKET_TRACKING_API_ROOT"]
  AUTH_TOKEN = ENV["TICKET_TRACKING_AUTH_TOKEN"]

  def client
    @_client ||= Faraday.new(TICKET_TRACKING_API_ROOT) do |client|
      client.adapter(Faraday.default_adapter)
      client.headers['Authorization'] = "token #{AUTH_TOKEN}"
      client.headers['Content-Type'] = 'application/json'
    end
  end

  def request(http_method:, endpoint:, params: {})
    @_response = client.public_send(http_method, endpoint, params)
    parsed_response = JSON.parse(@_response.body)
    return parsed_response if response_successful?

    raise error_class, "Code: #{@_response.status}, response: #{@_response.body}"
  end

  def error_class
    case @_response.status
    when HTTP_BAD_REQUEST_CODE
      BadRequestError
    when HTTP_UNAUTHORIZED_CODE
      UnauthorizedError
    when HTTP_FORBIDDEN_CODE
      ForbiddenError
    when HTTP_NOT_FOUND_CODE
      NotFoundError
    when HTTP_UNPROCESSABLE_ENTITY_CODE
      UnprocessableEntityError
    else
      GenericApiError
    end
  end

  def response_successful?
    @_response.status == HTTP_OK_CODE
  end
end

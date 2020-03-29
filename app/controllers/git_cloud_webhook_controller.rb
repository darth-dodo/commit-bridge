class GitCloudWebhookController < BaseWebhookController
  def receive
    event = JSON.parse(request.body.read)

    service = GitCloudWebhook::EventParserService.new(event)

    if service.execute
      render(json: service.service_response_data, status: :ok)
    else
      render(json: service.service_response_data, status: :bad_request)
    end

  rescue JSON::ParserError
    head(:unprocessable_entity)
  end
end

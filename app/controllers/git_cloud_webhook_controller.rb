class GitCloudWebhookController < BaseWebhookController
  def receive
    event = JSON.parse(request.body.read)

    service = GitCloudWebhook::EventParserService.new(event)
    service.execute!

    json_response(service.service_response_data)

  rescue JSON::ParserError
    head(:unprocessable_entity)
  end
end

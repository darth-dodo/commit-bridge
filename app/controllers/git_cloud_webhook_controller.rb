class GitCloudWebhookController < BaseWebhookController
  def receive
    event = JSON.parse(request.body.read)

    service = GitCloudWebhook::WebhookEventParser.new(event)
    service.execute!

    json_response(service.service_response_data)

  rescue JSON::ParserError
    head(:unprocessable_entity)
  end

  def echo
    data = JSON.parse(request.body.read)
    data[:time] = Time.now
    json_response(data)
  end
end

class GitCloudWebhookController < BaseWebhookController
  def receive
    begin
      event = JSON.parse(request.body.read)
      pp(event)
    rescue JSON::ParserError
      head(:unprocessable_entity)
    end
    head(:ok)
  end
end

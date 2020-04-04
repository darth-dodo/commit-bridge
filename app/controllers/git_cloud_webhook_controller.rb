class GitCloudWebhookController < BaseWebhookController
  def receive
    event = JSON.parse(request.body.read)

    webhook_service = GitCloudWebhook::WebhookEventParser.new(event)
    webhook_service.execute!
    event_id = webhook_service.service_response_data[:event_id]

    # tracking_service = SyncEventCommitsWithTrackingApi.new(event_id)
    # tracking_service.execute!

    controller_response_data = {}
    controller_response_data[:webhook_service] = webhook_service.service_response_data
    # controller_response_data[:tracking_service] = tracking_service.service_response_data

    json_response(controller_response_data, :created)

  rescue JSON::ParserError
    head(:unprocessable_entity)
  end

  def echo
    data = JSON.parse(request.body.read)
    data[:time] = Time.now
    # render(json: data, status: :internal_server_error) # generic api error 500
    # render json: data, status: :bad_request # bad request error 400
    # render json: data, status: :unauthorized # unauthorized error 401
    # render json: data, status: :forbidden # forbidden error 403
    # render json: data, status: :not_found # 404
    # render json: data, status: :unprocessable_entity # 422
    render(json: data, status: :ok) # OK 200
  end
end

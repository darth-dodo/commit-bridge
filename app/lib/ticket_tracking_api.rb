module TicketTrackingApi
  # new_client = TicketTrackingApi::Client.new()
  # payload = {"query": "released", "issues": [{"id": 66}]}
  # new_client.update_tickets_across_commit(payload)

  class Client
    include TicketTrackingCommunicator

    UPDATE_TICKETS_ACROSS_COMMIT = ENV["UPDATE_TICKETS_ACROSS_COMMIT"]

    def initialize
    end

    def update_tickets_across_commit(payload = {})
      request(http_method: :post, endpoint: UPDATE_TICKETS_ACROSS_COMMIT, params: payload.to_json)
    end
  end
end

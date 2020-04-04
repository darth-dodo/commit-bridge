module TicketTrackingApi
  # z = TicketTrackingApi::Client.new()
  # payload = {apples: "are super yummy", bananas: "are super funny"}
  # z.ready_for_release(payload)

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

module TicketTrackingApi
  # z = TicketTrackingApi::Client.new()
  # payload = {apples: "are super yummy", bananas: "are super funny"}
  # z.ready_for_release(payload)

  class Client
    include TicketTrackingCommunicator

    TICKET_UPDATE_ENDPOINT = ENV["TICKET_UPDATE_ENDPOINT"]

    def initialize
    end

    def ready_for_release(payload = {})
      request(http_method: :post, endpoint: TICKET_UPDATE_ENDPOINT, params: payload.to_json)
    end
  end
end

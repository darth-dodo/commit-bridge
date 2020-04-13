require 'rails_helper'

RSpec.describe("SyncEventCommitsWithTrackingApi") do
  let(:external_service_root_url) { ENV["TICKET_TRACKING_API_ROOT"] }
  let(:api_payload) { { "dummy": "payload" } }
  let(:success_stubbed_response) { { "updated_ticket_ids" => [121, 222, 66] } }

  def stub_external_ticketing_service_call_with_success
    stub_request(:post, /#{external_service_root_url}/)
      .to_return(status: 200,
        body: success_stubbed_response.to_json,
        headers: { 'Content-Type' => 'application/json' })
  end

  def execute_service(payload)
    service_instance = SyncEventCommitsWithTrackingApi.new(payload)
    service_instance.execute
    service_instance
  end

  describe "Stubbing external calls" do
    it "should successfully stub the API call with success response" do
      stub_external_ticketing_service_call_with_success
      api_client = TicketTrackingApi::Client.new
      response = api_client.update_tickets_across_commit(api_payload)
      expect(response).to(eq(success_stubbed_response))
    end
  end
end

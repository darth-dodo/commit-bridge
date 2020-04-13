require 'rails_helper'

RSpec.describe("SyncEventCommitsWithTrackingApi") do
  let(:external_service_root_url) { ENV["TICKET_TRACKING_API_ROOT"] }
  let(:api_payload) { { "dummy": "payload" } }
  let(:success_stubbed_response) { { "updated_ticket_ids" => [121, 222, 66] } }
  let(:error_stubbed_response) { { "error_message" => "Something went wrong!" } }

  def stub_external_ticketing_service_call_with_success
    stub_request(:post, /#{external_service_root_url}/)
      .to_return(status: 200,
        body: success_stubbed_response.to_json,
        headers: { 'Content-Type' => 'application/json' })
  end

  def stub_external_ticketing_service_call_with_exception(exception_status_code)
    stub_request(:post, /#{external_service_root_url}/)
      .to_return(status: exception_status_code,
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

    it "should successfully stub the API call with error response 500" do
      stub_external_ticketing_service_call_with_exception(500)
      api_client = TicketTrackingApi::Client.new
      expect { api_client.update_tickets_across_commit(api_payload) }
        .to(raise_error(ExternalExceptions::GenericApiError))
    end

    it "should successfully stub the API call with error response 401" do
      stub_external_ticketing_service_call_with_exception(401)
      api_client = TicketTrackingApi::Client.new
      expect { api_client.update_tickets_across_commit(api_payload) }
        .to(raise_error(ExternalExceptions::UnauthorizedError))
    end

    it "should successfully stub the API call with error response 403" do
      stub_external_ticketing_service_call_with_exception(403)
      api_client = TicketTrackingApi::Client.new
      expect { api_client.update_tickets_across_commit(api_payload) }
        .to(raise_error(ExternalExceptions::ForbiddenError))
    end

    it "should successfully stub the API call with error response 400" do
      stub_external_ticketing_service_call_with_exception(400)
      api_client = TicketTrackingApi::Client.new
      expect { api_client.update_tickets_across_commit(api_payload) }
        .to(raise_error(ExternalExceptions::BadRequestError))
    end
  end
end

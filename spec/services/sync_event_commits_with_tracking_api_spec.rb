require 'rails_helper'

RSpec.describe("SyncEventCommitsWithTrackingApi") do
  let(:external_service_root_url) { ENV["TICKET_TRACKING_API_ROOT"] }
  let(:api_payload) { { "dummy": "payload" } }
  let(:success_stubbed_response) { { "updated_ticket_ids" => [121, 222, 66] } }
  let(:error_stubbed_response) { { "error_message" => "Something went wrong!" } }
  let(:push_request_event) { create(:push_request_event) }
  let(:pull_request_event) { create(:pull_request_event) }

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

  describe "Service Validations" do
    before(:each) do
      stub_external_ticketing_service_call_with_success
    end

    it "should validate that the event should be present" do
      non_existent_event_id = Faker::Number.number(digits: 2)
      service_instance = execute_service(non_existent_event_id)

      expect(service_instance.errors.size).to(eq(1))
      expect(service_instance.errors.first).to(eq("Event is required for scheduling ticket tracking sync!"))
    end

    it "should validate the event commits are attached to the provided event" do
      event = create(:event)
      service_instance = execute_service(event.id)

      expect(service_instance.errors.size).to(eq(1))
      expect(service_instance.errors.first).to(eq("Event does not have any commits attached to it!"))
    end
  end

  describe "Service Execution" do
    it "should check that no sync is created for pull request event" do
      expect(EventCommitSync.count).to(eq(0))

      stub_external_ticketing_service_call_with_success
      create(:event_commit, event: pull_request_event)
      service_instance = execute_service(pull_request_event.id)

      expect(service_instance.errors.blank?).to(be(true))

      expect(EventCommitSync.count).to(eq(0))
    end

    it "should check that service is successful for push request event" do
      expect(EventCommitSync.count).to(eq(0))

      stub_external_ticketing_service_call_with_success
      create(:event_commit, event: push_request_event)
      create(:event_commit, event: push_request_event)

      service_instance = execute_service(push_request_event.id)

      expect(service_instance.errors.blank?).to(be(true))

      expect(EventCommitSync.count).to(eq(2))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_commit_sync_objects = response_hashie.event_commit_sync

      first_sync = EventCommitSync.find(event_commit_sync_objects.first.id)
      second_sync = EventCommitSync.find(event_commit_sync_objects.last.id)

      expect(first_sync.successful?).to(be(true))
      expect(second_sync.successful?).to(be(true))
    end
  end

  describe "Service Execution Errors" do
    it "should handle 400 from external service" do
      stub_external_ticketing_service_call_with_exception(400)
      expect(EventCommitSync.count).to(eq(0))

      current_event_commit = create(:event_commit, event: push_request_event)
      service_instance = execute_service(push_request_event.id)

      expect(EventCommitSync.count).to(eq(1))

      event_commit_sync_object = EventCommitSync.first
      expect(event_commit_sync_object.failed?).to(be(true))

      commit_sha = current_event_commit.commit.sha
      error_message = "API call failed for Commit SHA: #{commit_sha} with status code 400"
      expect(service_instance.errors.first).to(eq(error_message))
    end

    it "should handle 401 from external service" do
      stub_external_ticketing_service_call_with_exception(401)
      expect(EventCommitSync.count).to(eq(0))

      current_event_commit = create(:event_commit, event: push_request_event)
      service_instance = execute_service(push_request_event.id)

      expect(EventCommitSync.count).to(eq(1))

      event_commit_sync_object = EventCommitSync.first
      expect(event_commit_sync_object.failed?).to(be(true))

      commit_sha = current_event_commit.commit.sha
      error_message = "API call failed for Commit SHA: #{commit_sha} with status code 401"
      expect(service_instance.errors.first).to(eq(error_message))
    end

    it "should handle 403 from external service" do
      stub_external_ticketing_service_call_with_exception(403)
      expect(EventCommitSync.count).to(eq(0))

      current_event_commit = create(:event_commit, event: push_request_event)
      service_instance = execute_service(push_request_event.id)

      expect(EventCommitSync.count).to(eq(1))

      event_commit_sync_object = EventCommitSync.first
      expect(event_commit_sync_object.failed?).to(be(true))

      commit_sha = current_event_commit.commit.sha
      error_message = "API call failed for Commit SHA: #{commit_sha} with status code 403"
      expect(service_instance.errors.first).to(eq(error_message))
    end

    it "should handle 500 from external service" do
      stub_external_ticketing_service_call_with_exception(500)
      expect(EventCommitSync.count).to(eq(0))

      current_event_commit = create(:event_commit, event: push_request_event)
      service_instance = execute_service(push_request_event.id)

      expect(EventCommitSync.count).to(eq(1))

      event_commit_sync_object = EventCommitSync.first
      expect(event_commit_sync_object.failed?).to(be(true))

      commit_sha = current_event_commit.commit.sha
      error_message = "API call failed for Commit SHA: #{commit_sha} with status code 500"
      expect(service_instance.errors.first).to(eq(error_message))
    end
  end
end

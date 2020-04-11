require 'rails_helper'

RSpec.describe("ReleaseRequestParserSpec Service") do
  let(:service_payload) { load_json_from_fixture("spec/fixtures/release_request_payload.json") }
  let(:second_service_payload) { load_json_from_fixture("spec/fixtures/services/release_request_payload_2.json") }

  def execute_service(payload)
    service_instance = ReleaseRequestParser.new(payload)
    service_instance.execute
    service_instance
  end

  describe "Service Validations" do
    it "should validate repository information is required" do
      service_payload.delete("repository")
      service_instance = execute_service(service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Repository information is required!"))
    end

    it "should validate pusher information is required" do
      service_payload.delete("release")
      service_instance = execute_service(service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Release Author information is required!"))
    end

    it "should validate commit information is required" do
      malformed_release_info = service_payload["release"]
      malformed_release_info.delete("commits")
      service_payload["release"] = malformed_release_info
      service_instance = execute_service(service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Commit information is required!"))
    end

    it "should validate commit payload structuring" do
      service_payload["release"]["commits"] = "Wrong data format"
      service_instance = execute_service(service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Commit payload structuring"))
    end
  end

  describe "Service Execution" do
    it "should find or create a repo object" do
      payload_repo_application_id = service_payload["repository"]["id"]
      expect(Repository.count).to(eq(0))

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      expect(Event.count).to(eq(1))

      expect(Repository.count).to(eq(1))
      new_repo_application_id = Repository.first.application_id
      expect(new_repo_application_id).to(eq(payload_repo_application_id))

      second_event_service = execute_service(second_service_payload)
      expect(second_event_service.errors.blank?).to(be(true))

      expect(Repository.count).to(eq(1))

      expect(Event.count).to(eq(2))
    end

    it "should create the event object with proper event type" do
      expect(Event.count).to(eq(0))

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      expect(Event.count).to(eq(1))
      event = Event.first
      expect(event.release?).to(be(true))
    end

    it "should attach the user and repo to the event object" do
      payload_user_application_id = service_payload["release"]["author"]["id"]
      payload_repo_application_id = service_payload["repository"]["id"]

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      user_object = User.find_by_application_id(payload_user_application_id)
      repo_object = Repository.find_by_application_id(payload_repo_application_id)

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event

      expect(event_object.user_id).to(eq(user_object.id))
      expect(event_object.repository_id).to(eq(repo_object.id))
    end

    it "should successfully generate the commit objects" do
      payload_commits_substructure = service_payload["release"]["commits"]
      payload_commits_count = payload_commits_substructure.size

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event

      expect(event_object.commits.count).to(eq(payload_commits_count))
    end

    it "should successfully attach the event to the tickets" do
      expect(EventTicket.count).to(eq(0))
      expect(Ticket.count).to(eq(0))

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event

      expect(event_object.tickets.count).to(eq(Ticket.count))
    end

    it "should check that a new release object is created" do
      expect(Release.count).to(eq(0))
      execute_service(service_payload)
      expect(Release.count).to(eq(1))
    end

    it "should check the release timestamp" do
      release_timestamp_from_payload = service_payload["released_at"]
      execute_service(service_payload)
      release_obj = Release.first
      expect(release_obj.released_at).to(eq(release_timestamp_from_payload))
    end

    it "should check for the release tag" do
      release_tag_from_payload = service_payload["release"]["tag_name"]
      execute_service(service_payload)
      release_obj = Release.first
      expect(release_obj.tag).to(eq(release_tag_from_payload))
    end

    it "should that the release is linked to the event" do
      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event

      expect(event_object.release.present?).to(be(true))
      release_obj = Release.first
      expect(release_obj.event_id).to(eq(event_object.id))
    end

    it "should provide consistent service response data keys" do
      service_instance = execute_service(service_payload)
      response_hashie = get_hashie(service_instance.service_response_data)
      top_level_keys = response_hashie.keys
      expect(top_level_keys).to(eq(["commits", "tickets", "event", "event_id"]))
    end
  end

  describe "Service Execution Failures" do
    it "should fail to create event object due to identical payload" do
      expect(Event.count).to(eq(0))

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))

      expect(Event.count).to(eq(1))

      erroneous_service_instance = execute_service(service_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))
      expect(erroneous_service_instance.errors.first)
        .to(eq("Event Creation Error: Payload present across existing event of the same type!"))
    end

    it "should fail to create repo object due to duplicate application id and rollback" do
      payload_repo_application_id = service_payload["repository"]["id"]
      expect(Repository.count).to(eq(0))

      service_instance = execute_service(service_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))

      expect(Repository.count).to(eq(1))
      new_repo_application_id = Repository.first.application_id
      expect(new_repo_application_id).to(eq(payload_repo_application_id))

      malformed_repo_data_for_second_event = service_payload["repository"]
      malformed_repo_data_for_second_event["name"] = malformed_repo_data_for_second_event["name"].prepend("malformed_")
      service_payload["repository"] = malformed_repo_data_for_second_event

      erroneous_service_instance = execute_service(service_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))
      expect(erroneous_service_instance.errors.first).to(eq("Repository Error: Application ID has already been taken"))

      expect(Repository.count).to(eq(1))
      expect(Event.count).to(eq(1))
    end

    it "should fail to create user object due to duplicate application id and rollback" do
      legacy_user = create(:user)

      service_payload["release"]["author"]["id"] = legacy_user.application_id

      expect(Event.count).to(eq(0))
      expect(Repository.count).to(eq(0))

      erroneous_service_instance = execute_service(service_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))
      expect(erroneous_service_instance.errors.first)
        .to(eq("Release Author Error: Application ID has already been taken"))

      expect(Event.count).to(eq(0))
      expect(Repository.count).to(eq(0))
    end

    it "should fail while generating commit objects and rollback event creation" do
      expect(Commit.count).to(eq(0))
      expect(Event.count).to(eq(0))
      expect(Release.count).to(eq(0))

      # just duplicate the commits and the commit parser service will break on the "second" duplicate iteration
      # this will result in rollback of the Event creation
      payload_commits_substructure = service_payload["release"]["commits"]
      duplicate_commits = payload_commits_substructure.concat(payload_commits_substructure)
      service_payload["release"]["commits"] = duplicate_commits

      erroneous_service_instance = execute_service(service_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))

      expect(Commit.count).to(eq(0))
      expect(Event.count).to(eq(0))
      expect(Release.count).to(eq(0))
    end
  end
end

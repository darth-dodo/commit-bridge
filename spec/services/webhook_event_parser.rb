require 'rails_helper'

RSpec.describe(WebhookEventParser) do
  let(:ideal_pull_request_payload) { load_json_from_fixture("spec/fixtures/pull_request_payload.json") }
  let(:second_ideal_pull_request_payload) do
    load_json_from_fixture("spec/fixtures/services/pull_request_payload_2.json")
  end
  let(:ideal_push_request_payload) { load_json_from_fixture("spec/fixtures/push_request_payload.json") }
  let(:ideal_release_request_payload) { load_json_from_fixture("spec/fixtures/release_request_payload.json") }

  def execute_service(payload)
    service_instance = WebhookEventParser.new(payload)
    service_instance.execute
    service_instance
  end

  describe "Service Validations" do
    it "should validate event strategy identifier is present for pull request due to malformed action" do
      ideal_pull_request_payload[:action] = "dummy"
      service_instance = execute_service(ideal_pull_request_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Event type!"))
    end

    it "should validate event strategy identifier is present for push request due to malformed pushed_at data" do
      ideal_push_request_payload[:pushed_at] = nil
      service_instance = execute_service(ideal_push_request_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Event type!"))
    end

    it "should validate event strategy identifier is present for push request due to malformed pusher data" do
      ideal_push_request_payload[:pusher] = nil
      service_instance = execute_service(ideal_push_request_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Event type!"))
    end

    it "should validate event strategy identifier is present for release request due to malformed action" do
      ideal_release_request_payload[:action] = "dummy"
      service_instance = execute_service(ideal_release_request_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Event type!"))
    end
  end

  describe "Service Execution" do
    it "should validate pull request event uses pull request parser strategy" do
      service_instance = execute_service(ideal_pull_request_payload)
      expect(service_instance.strategy.class).to(be(PullRequestParser))
    end

    it "should validate pull request event uses push request parser strategy" do
      service_instance = execute_service(ideal_push_request_payload)
      expect(service_instance.strategy.class).to(be(PushRequestParser))
    end

    it "should validate pull request event uses release request parser strategy" do
      service_instance = execute_service(ideal_release_request_payload)
      expect(service_instance.strategy.class).to(be(ReleaseRequestParser))
    end

    it "should validate pull request event is created for action closed" do
      expect(Event.count).to(eq(0))

      ideal_pull_request_payload[:action] = "closed"
      service_instance = execute_service(ideal_pull_request_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event
      expect(event_object.pull_request?).to(be(true))
    end

    it "should validate pull request event is created for action approved" do
      expect(Event.count).to(eq(0))

      ideal_pull_request_payload[:action] = "approved"
      service_instance = execute_service(ideal_pull_request_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event
      expect(event_object.pull_request?).to(be(true))
    end

    it "should validate pull request event is created for action created" do
      expect(Event.count).to(eq(0))

      ideal_pull_request_payload[:action] = "created"
      service_instance = execute_service(ideal_pull_request_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event
      expect(event_object.pull_request?).to(be(true))
    end

    it "should validate push request event is created" do
      expect(Event.count).to(eq(0))

      service_instance = execute_service(ideal_push_request_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event
      expect(event_object.push_request?).to(be(true))
    end

    it "should validate release request event and release is created" do
      expect(Event.count).to(eq(0))
      expect(Release.count).to(eq(0))

      service_instance = execute_service(ideal_release_request_payload)
      expect(service_instance.errors.blank?).to(be(true))
      expect(Event.count).to(eq(1))
      expect(Release.count).to(eq(1))

      response_hashie = get_hashie(service_instance.service_response_data)
      event_object = response_hashie.event
      expect(event_object.release?).to(be(true))
      expect(event_object.release.present?).to(be(true))
      release_object = Release.first
      expect(release_object.event_id).to(eq(event_object.id))
    end
  end

  describe "Service Execution Failures" do
    # rolling back by adding duplicate commit SHAs to the payloads
    it "should no events or commits are created if pull request service rolls back" do
      expect(Event.count).to(eq(0))

      commit_data = ideal_pull_request_payload["pull_request"]["commits"]
      malformed_commit_data = commit_data.concat(commit_data)
      ideal_pull_request_payload["pull_request"]["commits"] = malformed_commit_data
      erroneous_service_instance = execute_service(ideal_pull_request_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))

      expect(Event.count).to(eq(0))
    end

    it "should no events or commits are created if push request service rolls back" do
      expect(Event.count).to(eq(0))

      commit_data = ideal_push_request_payload["commits"]
      malformed_commit_data = commit_data.concat(commit_data)
      ideal_push_request_payload["commits"] = malformed_commit_data
      erroneous_service_instance = execute_service(ideal_push_request_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))

      expect(Event.count).to(eq(0))
    end

    it "should no events or commits are created if release request service rolls back" do
      expect(Event.count).to(eq(0))
      expect(Release.count).to(eq(0))

      commit_data = ideal_release_request_payload["release"]["commits"]
      malformed_commit_data = commit_data.concat(commit_data)
      ideal_release_request_payload["release"]["commits"] = malformed_commit_data
      erroneous_service_instance = execute_service(ideal_release_request_payload)
      expect(erroneous_service_instance.errors.present?).to(be(true))

      expect(Event.count).to(eq(0))
      expect(Release.count).to(eq(0))
    end
  end
end

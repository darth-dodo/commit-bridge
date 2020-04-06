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

  # describe "Service Execution" do
  #   it "should validate pull request event is created" do
  #
  #   end
  #
  #   it "should validate push request event is created" do
  #
  #   end
  #
  #   it "should validate release request event and release is created" do
  #
  #   end
  #
  #   # rolling back by adding duplicate commit SHAs to the payloads
  #   it "should no events or commits are created if pull request service rolls back" do
  #
  #   end
  #
  #   it "should no events or commits are created if push request service rolls back" do
  #
  #   end
  #
  #   it "should no events or commits are created if release request service rolls back" do
  #
  #   end
  # end
end

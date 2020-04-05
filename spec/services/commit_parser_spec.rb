require 'rails_helper'

RSpec.describe(CommitParser) do
  let(:ideal_payload) { load_json_from_fixture("spec/fixtures/services/commit_parser_payload.json") }
  let(:new_event) { create(:pull_request_event) }
  let(:ideal_service_payload) { ideal_payload.merge({ "event": new_event }) }

  def execute_service(payload)
    service_instance = CommitParser.new(payload)
    service_instance.execute
    service_instance
  end

  describe "Service Validations" do
    it "should check that event is required for absent event data" do
      ideal_service_payload.delete(:event)
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Event is required!"))
    end

    it "should check that event is required for invalid event id" do
      ideal_service_payload["event"] = Event.last.id + 1
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Event is required!"))
    end

    it "should check that commit message is required" do
      ideal_service_payload.delete("message")
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Commit message is required!"))
    end

    it "should check that commit author is required" do
      ideal_service_payload.delete("author")
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Commit Author is required!"))
    end
  end

  describe "Service Execution" do
  end
end

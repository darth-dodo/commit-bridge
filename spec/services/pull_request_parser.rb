require 'rails_helper'

RSpec.describe(PullRequestParser) do
  let(:ideal_service_payload) { load_json_from_fixture("spec/fixtures/pull_request_payload.json") }

  def execute_service(payload)
    service_instance = PullRequestParser.new(payload)
    service_instance.execute
    service_instance
  end

  describe "Service Validations" do
    it "should validate presence of repository information" do
      ideal_service_payload.delete("repository")
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Repository information is required!"))
    end

    it "should validate presence of user information" do
      ideal_service_payload.delete("pull_request")
      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Pull request User information is required!"))
    end

    it "should validate presence of user information" do
      malformed_pull_request_info = ideal_service_payload["pull_request"]
      malformed_pull_request_info.delete("commits")
      ideal_service_payload["pull_request"] = malformed_pull_request_info

      service_instance = execute_service(ideal_service_payload)
      expect(service_instance.errors.present?).to(be(true))
      expect(service_instance.errors.first).to(eq("Invalid Commits structuring"))
    end
  end
end

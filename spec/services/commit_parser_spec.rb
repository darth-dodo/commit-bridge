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
    it "should check author is created and attributed to commit" do
      author_email = get_hashie(ideal_service_payload).author.email
      expect(User.find_by_email(author_email)).to(be(nil))

      service_instance = execute_service(ideal_service_payload)
      expect(User.exists?(email: author_email)).to(be(true))
      author = User.find_by(email: author_email)

      service_response_hashie = get_hashie(service_instance.service_response_data)
      commit_sha = service_response_hashie.commit.sha
      commit = Commit.find_by(sha: commit_sha)
      expect(commit.user).to(eq(author))
    end

    it "should check commit is created with the payload sha and message" do
      payload_hashie = get_hashie(ideal_service_payload)
      commit_message = payload_hashie.message
      commit_sha = payload_hashie.sha

      expect(Commit.exists?(message: commit_message)).to(be(false))
      expect(Commit.exists?(sha: commit_sha)).to(be(false))

      execute_service(ideal_service_payload)

      expect(Commit.exists?(message: commit_message)).to(be(true))
      expect(Commit.exists?(sha: commit_sha)).to(be(true))
    end

    it "should check ticket objects are created from the commit" do
      expect(Project.all.size).to(eq(0))
      expect(Ticket.all.size).to(eq(0))

      service_instance = execute_service(ideal_service_payload)
      service_response_hashie = get_hashie(service_instance.service_response_data)

      commit_sha = service_response_hashie.commit.sha
      commit = Commit.find_by(sha: commit_sha)

      expect(commit.tickets.exists?).to(be(true))
      expect(Ticket.all.size).to(eq(commit.tickets.size))
      expect(Project.all.size).to(eq(commit.tickets.pluck('project_id').uniq.size))
    end

    it "should check the commit is attached to the required tickets" do
    end

    it "should check commit is attached to the event" do
    end

    it "should check whether release is attached to a commit due to release event" do
    end

    it "should validate service response data keys" do
    end
  end
end

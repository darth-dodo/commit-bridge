class SyncEventCommitsWithTrackingApi < ApplicationService
  def initialize(event_id)
    super()
    @event_id = event_id
  end

  def validate
    @event = Event.find(@event_id)
    error('Event is required for scheduling ticket tracking sync!') if @event.blank?
    @event_commits = @event.event_commits

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?
    all_payloads = []

    # don't run the sync in case of the following conditions
    return valid? if no_sync_required

    @event_commits.each do |current_event_commit|
      current_commit_sha = current_event_commit.commit.sha
      sync_object = create_event_commit_sync_object(current_event_commit)

      if sync_object.errors.present?
        next
      end

      api_payload = create_api_payload_from_event_commit(current_event_commit)
      all_payloads << api_payload

      begin
        trigger_tracking_sync_api(api_payload)
      rescue CommitBridgeExceptions::ExternalApiException => e
        sync_object.failed!
        sync_object.response_payload = e.response
        sync_object.save
        error("API call failed for Commit SHA: #{current_commit_sha} with status code #{e.status_code}")
      end
    end

    valid?
  end

  private

  def no_sync_required
    true if @event.pull_request?
  end

  def create_event_commit_sync_object(event_commit)
    event_commit_sync = EventCommitSync.new
    event_commit_sync.event_commit = event_commit
    event_commit_sync.status = :pending

    unless event_commit_sync.save
      error(event_commit_sync.errors.full_messages.map do |current_error|
        current_error.prepend("Event Commit Sync Creation Error for Commit SHA #{event_commit.commit.sha}: ")
      end)
    end
    event_commit_sync
  end

  def create_api_payload_from_event_commit(event_commit)
    event = event_commit.event
    commit = event_commit.commit

    if event.push_request?
      return generate_push_event_ticket_tracking_payload_from_commit(commit)
    end

    if event.release?
      return generate_release_event_ticket_tracking_payload_from_commit(commit)
    end

    error("Unable to create API payload for for Commit SHA #{commit.sha}")
  end

  def generate_push_event_ticket_tracking_payload_from_commit(commit)
    api_payload = {}
    api_payload["query"] = "state \#{ready for release}"
    api_payload["issues"] = attach_ticket_codes_from_commit(commit)
    api_payload["comment"] = "See SHA ##{commit.sha}"
    api_payload
  end

  def generate_release_event_ticket_tracking_payload_from_commit(commit)
    api_payload = {}
    api_payload["query"] = "state \#{released}"
    api_payload["issues"] = attach_ticket_codes_from_commit(commit)
    api_payload["comment"] = "Released in #{commit.release.tag}"
    api_payload
  end

  def attach_ticket_codes_from_commit(commit)
    all_codes = []
    attached_ticket_commits = commit.ticket_commits
    attached_ticket_commits.each do |current_ticket_commit|
      current_code = {}
      current_code[:id] = current_ticket_commit.ticket.hash_code
      all_codes << current_code
    end
    all_codes
  end

  def trigger_tracking_sync_api(api_payload)
    api_client = TicketTrackingApi::Client.new
    api_client.update_tickets_across_commit(api_payload)
  end
end

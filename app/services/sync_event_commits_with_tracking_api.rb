class SyncEventCommitsWithTrackingApi < ApplicationService

  def initialize(event_id)
    super()
    @event_id = event_id
  end

  def validate
    @event = Event.find(@event_id)
    error 'Event is required for scheduling ticket tracking sync!' if @event.blank?
    @commits = @event.commits
    super()
    valid?
  end

  def execute
    super()
    return false unless valid?

    # don't run the sync in case of the following conditions
    return valid? if no_sync_required

    create_event_tracking_sync_object
    return false unless valid?

    create_tracking_api_payload

    begin
      trigger_tracking_sync_api
    rescue CommitBridgeExceptions::ExternalApiException => e
      binding.pry
      puts e
    end

  end

  private
  def no_sync_required
    return true if @event.pull_request?
  end

  def create_event_commit_sync_object
    @event_commit_sync = EventCommitSync.new
    @event_commit_sync.event_commit = @event
    @event_commit_sync.status = :pending

    unless @event_tracking_sync.save
      error(@event_tracking_sync.errors.full_messages.map do |current_error|
        current_error.prepend("Event Tracking Sync Creation Error: ")
      end)
    end

  end

  def create_tracking_api_payload
    if @event.push_request?
      generate_push_event_ticket_tracking_payload
    end

    if @event.release?
      generate_release_event_ticket_tracking_payload
    end
  end

  def generate_push_event_ticket_tracking_payload
    @api_payload = {}
    @api_payload["query"] = "state \#{ready for release}"
    @api_payload["issues"] = attach_event_ticket_codes
    @api_payload["comment"] = "See SHA ##{}"

  end

  def generate_release_event_ticket_tracking_payload

  end

  def trigger_tracking_sync_api
  end

end

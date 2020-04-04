class PullRequestParser < ApplicationService
  include GitWebhookServiceHelpers
  #   - Consume `GitWehookServiceHelpers` to store the common logic
  #   - Get or Create Repo object
  #   - Get or Create User object
  #   - Rollback all the operations if any errors
  #   - Create New Event Object of the type `:pull_request`
  #   - Rollback all the operations if any errors
  #   - Create all the commits using the `CommitParser` Service
  #   - Rollback all the operations if any errors
  #   - Attach the Tickets to the Event

  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @repository_info = @context.repository
    pull_request_info = @context.pull_request
    @event_created_at = pull_request_info.try(:created_at)
    @event_user_info = pull_request_info.try(:user)
    @commit_info = pull_request_info.try(:commits)
  end

  def validate
    error('Repository information is required!') if @repository_info.blank?
    error('Pull request User information is required!') if @event_user_info.blank?
    error('Invalid Commits structuring') unless @commit_info.is_a?(Array)

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?

    ActiveRecord::Base.transaction do
      find_or_create_repo_object
      find_or_create_user_object("Pull Request User Error: ")
      raise_rollback_unless_valid

      create_event_object(:pull_request)
      raise_rollback_unless_valid

      execute_commit_payload_parser_service_for_event
      raise_rollback_unless_valid

      attach_event_to_tickets
    end

    # do not continue without checking for errors in the event of a rollback
    # assume the internals will populate the errors to navigate the code flow
    # and those errors need to be bubbled upward in the application
    return false unless valid?

    create_service_response_data
    valid?
  end
end

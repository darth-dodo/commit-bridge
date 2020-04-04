class PushRequestParser < ApplicationService
  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @repository_info = @context.repository
    @commit_info = @context.commits
    @pushed_at = @context.pushed_at
    @pusher_info = @context.pusher
  end

  def validate
    error('Repository information is required!') if @repository_info.blank?
    error('Pusher information is required!') if @pusher_info.blank?
    error('Commit information is required!') if @commit_info.blank?
    error('Invalid Commits structuring') unless @commit_info.is_a?(Array)

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?

    ActiveRecord::Base.transaction do
      set_repo_object
      set_pusher_object
      raise_rollback_unless_valid

      create_event_object
      raise_rollback_unless_valid

      execute_commit_payload_parser_service_for_event
      raise_rollback_unless_valid

      attach_event_to_tickets
    end

    create_service_response_data

    valid?
  end

  private

  def set_repo_object
    @repo = Repository.find_or_create_by(application_id: @repository_info.id,
                                        slug: @repository_info.name)
    if @repo.errors.present?
      error(@repo.errors.full_messages.map { |current_error| current_error.prepend("Repository Error: ") })
    end
  end

  def set_pusher_object
    @pusher = User.find_or_create_by(application_id: @pusher_info.id,
                                      name: @pusher_info.name,
                                      email: @pusher_info.email)
    if @pusher.errors.present?
      error(@pusher.errors.full_messages.map { |current_error| current_error.prepend("Pusher Error: ") })
    end
  end

  def create_event_object
    @event = Event.new
    @event.payload = @context
    @event.event_timestamp = @pushed_at
    @event.event_type = :push_request
    @event.repository = @repo
    @event.user = @pusher
    unless @event.save
      error(@event.errors.full_messages.map { |current_error| current_error.prepend("Event Creation Error: ") })
    end
  end

  def execute_commit_payload_parser_service_for_event
    @service_response_data[:commits] = []
    @service_response_data[:tickets] = []

    @commit_info.each do |current_commit|
      current_commit[:event] = @event
      commit_parser_service = CommitParser.new(current_commit)

      if commit_parser_service.execute
        commit = commit_parser_service.service_response_data[:commit]
        attached_tickets = commit_parser_service.service_response_data[:tickets]
        @service_response_data[:commits] << commit
        @service_response_data[:tickets] = @service_response_data[:tickets].concat(attached_tickets)
      else
        puts "Errors while parsing #{current_commit.sha}"
        commit_parser_service.errors.map do |current_error|
          current_error.prepend("Commit SHA: #{current_commit.sha} payload error: ")
        end
        error(commit_parser_service.errors)
      end
    end
  end

  def attach_event_to_tickets
    event = @event
    attached_tickets = @service_response_data[:tickets].uniq
    event.tickets << attached_tickets
  end

  def create_service_response_data
    @service_response_data[:event] = @event

    # share  only the unique tickets across all the commits attached to this event
    @service_response_data[:tickets] = @service_response_data[:tickets].uniq
  end
end

module GitWebhookServiceHelpers
  extend ActiveSupport::Concern

  private

  def find_or_create_repo_object
    @repo = Repository.find_or_create_by(application_id: @repository_info.id,
                                         slug: @repository_info.name)
    if @repo.errors.present?
      error(@repo.errors.full_messages.map { |current_error| current_error.prepend("Repository Error: ") })
    end
  end

  def find_or_create_user_object(error_prefix = nil)
    @user = User.find_or_create_by(application_id: @event_user_info.id,
                                   name: @event_user_info.name,
                                   email: @event_user_info.email)
    if @user.errors.present?

      if error_prefix.present?
        error(@user.errors.full_messages.map do |current_error|
          current_error.prepend(error_prefix)
        end)
      else
        error(@user.errors.full_messages)
      end

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

  def create_event_object(event_type)
    @event = Event.new
    @event.payload = @context
    @event.event_timestamp = @event_created_at
    @event.event_type = event_type
    @event.repository = @repo
    @event.user = @user

    unless @event.save
      error(@event.errors.full_messages.map { |current_error| current_error.prepend("Event Creation Error: ") })
    end
  end

  def create_service_response_data
    @service_response_data[:event] = @event

    # share  only the unique tickets across all the commits attached to this event
    @service_response_data[:tickets] = @service_response_data[:tickets].uniq
  end

  def attach_event_to_tickets
    attached_tickets = @service_response_data[:tickets].uniq
    @event.tickets << attached_tickets
  end
end

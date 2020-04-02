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

  def execute_commit_payload_parser_service
    @commit_info.each do |current_commit|
      current_commit[:event] = @event
      commit_creator_service = CommitParser.new(current_commit)

      next if commit_creator_service.execute
      puts "Errors while parsing #{current_commit.sha}"
      commit_creator_service.errors.map do |current_error|
        current_error.prepend("Commit SHA: #{current_commit.sha} payload error: ")
      end
      error(commit_creator_service.errors)
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
    @service_response_data = @event.as_json(except: [:payload], include: [:user, :repository])
  end
end

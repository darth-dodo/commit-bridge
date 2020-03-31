class PullRequestParser < ApplicationService
  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @repository_info = @context.repository
    @pull_request_info = @context.pull_request
    @pull_request_created_at = @pull_request_info.try(:created_at)
    @pull_request_user_info = @pull_request_info.try(:user)
    @commit_info = @pull_request_info.try(:commits)
  end

  def validate
    error('Repository information is required!') if @repository_info.blank?
    error('Pull request User information is required!') if @pull_request_user_info.blank?
    error('Invalid Commits structuring') unless @commit_info.is_a?(Array)

    super()
  end

  def execute
    super()
    return false unless valid?

    ActiveRecord::Base.transaction do
      set_repo_object
      set_pull_request_user_object
      raise_rollback_unless_valid

      create_event_object
      raise_rollback_unless_valid

      execute_commit_payload_parser_service
      raise_rollback_unless_valid
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

  def set_pull_request_user_object
    @pull_request_user = User.find_or_create_by(application_id: @pull_request_user_info.id,
                                                name: @pull_request_user_info.name,
                                                email: @pull_request_user_info.email)
    if @pull_request_user.errors.present?
      error(@pull_request_user.errors.full_messages.map do |current_error|
              current_error.prepend("Pull Request User Error: ")
            end)
    end
  end

  def create_event_object
    @event = Event.new
    @event.payload = @context
    @event.event_timestamp = @pull_request_created_at
    @event.event_type = :pull_request
    @event.repository = @repo
    @event.user = @pull_request_user

    unless @event.save
      error(@event.errors.full_messages.map { |current_error| current_error.prepend("Event Creation Error: ") })
    end
  end

  def execute_commit_payload_parser_service
    @commit_info.each do |current_commit|
      commit_creator_service = Mock::DemoService.new(current_commit)

      next if commit_creator_service.execute
      puts "Errors while parsing #{current_commit.sha}"

      # TODO: create a prepend error method in the base service
      commit_creator_service.errors.map do |current_error|
        current_error.prepend("Commit SHA: #{current_commit.sha} payload error: ")
      end
      error(commit_creator_service.errors)
    end
  end

  def create_service_response_data
    @service_response_data = @event.as_json(except: [:payload], include: [:user, :repository])
  end
end

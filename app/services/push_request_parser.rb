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

  def set_pusher_object
    @pusher = User.find_or_create_by(application_id: @pusher_info.id,
                                      name: @pusher_info.name,
                                      email: @pusher_info.email)
    if @pusher.errors.present?
      error(@pusher.errors.full_messages.map { |current_error| current_error.prepend("Pusher Error: ") })
    end
  end

  def create_event_object
    new_event = Event.new
    new_event.payload = @context
    new_event.event_timestamp = @pushed_at
    new_event.event_type = :release
    new_event.repository = @repo
    new_event.user = @pusher

    unless new_event.save
      error(new_event.errors.full_messages.map { |current_error| current_error.prepend("Event Creation Error: ") })
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
    @service_response_data = @event.as_json
  end
end

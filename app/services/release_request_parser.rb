class ReleaseRequestParser < ApplicationService
  include GitWebhookServiceHelpers
  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @repository_info = @context.repository
    release_request_info = @context.release
    @event_created_at = @context.released_at
    @event_user_info = release_request_info.try(:author)
    @release_tag = release_request_info.try(:tag_name)
    @release_application_id = release_request_info.try(:id)
    @commit_info = release_request_info.try(:commits)
    @created_commits = Commit.none
    @release = Release.new
  end

  def validate
    error('Repository information is required!') if @repository_info.blank?
    error('Release Author information is required!') if @event_user_info.blank?
    error('Commit information is required!') if @commit_info.blank?
    error('Invalid Commits structuring') unless @commit_info.is_a?(Array)

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?
    ActiveRecord::Base.transaction do
      find_or_create_repo_object
      find_or_create_user_object("Release Author Error: ")
      raise_rollback_unless_valid

      create_event_object(:release)
      raise_rollback_unless_valid

      execute_commit_payload_parser_service
      raise_rollback_unless_valid

      create_release_object
      attach_release_object_to_event_commits
      raise_rollback_unless_valid
    end

    create_service_response_data

    valid?
  end

  private

  def create_release_object
    @release = Release.new
    @release.released_at = @event_created_at
    @release.tag = @release_tag
    @release.application_id = @release_application_id
    @release.event = @event
    @release.save

    if @release.errors.present?
      error(@release.errors.full_messages.map { |current_error| current_error.prepend("Release Error: ") })
    end
  end

  def attach_release_object_to_event_commits
    # TODO: refactor this once the commit creator service is finished
    @created_commits.update_all(release: @release)
  end
end

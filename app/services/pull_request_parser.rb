class PullRequestParser < ApplicationService
  include GitWebhookServiceHelpers

  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @repository_info = @context.repository
    pull_request_info = @context.pull_request
    @event_created_at = pull_request_info.try(:created_at)
    @user_info = pull_request_info.try(:user)
    @commit_info = pull_request_info.try(:commits)
  end

  def validate
    error('Repository information is required!') if @repository_info.blank?
    error('Pull request User information is required!') if @user_info.blank?
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

      execute_commit_payload_parser_service
      raise_rollback_unless_valid
    end

    create_service_response_data

    valid?
  end
end

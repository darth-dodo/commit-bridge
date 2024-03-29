class WebhookEventParser < ApplicationService
  attr_reader :strategy

  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    @strategy = event_parsing_strategy
  end

  def validate
    error('Invalid Event type!') if @strategy.nil?
    super()
  end

  def execute
    super()
    return false unless valid?

    ActiveRecord::Base.transaction do
      unless @strategy.execute
        error(@strategy.errors)
        raise_rollback_unless_valid
      end
    end

    return false unless valid?

    @service_response_data = @strategy.service_response_data
    valid?
  end

  private

  def event_parsing_strategy
    return PushRequestParser.new(@context) if push_request_event?

    return PullRequestParser.new(@context.merge({ event: :pull_request })) if pull_request_event?

    return ReleaseRequestParser.new(@context.merge({ event: :release_request })) if release_request_event?
  end

  def pull_request_event?
    valid_pull_request_actions = %w[closed created approved]
    valid_pull_request_actions.include?(@context.action)
  end

  def push_request_event?
    @context.pushed_at.present? && @context.pusher.present?
  end

  def release_request_event?
    valid_release_request_actions = ["released"]
    valid_release_request_actions.include?(@context.action)
  end
end

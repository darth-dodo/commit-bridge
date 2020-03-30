module GitCloudWebhook
  class WebhookEventParser < ApplicationService
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
          raise ActiveRecord::Rollback
        end
      end
      @service_response_data = @strategy.service_response_data
      valid?
    end

    private

    def event_parsing_strategy
      return Mock::DemoService.new(@context.merge({ event: :pull_request })) if pull_request_event?

      return Mock::DemoService.new(@context.merge({ event: :push_request })) if push_request_event?

      return Mock::DemoService.new(@context.merge({ event: :release_request })) if release_request_event?
    end

    def pull_request_event?
      valid_pull_request_actions = %w[closed created approved]
      valid_pull_request_actions.include?(@context.try(:action))
    end

    def push_request_event?
      @context.try(:pushed_at).present? && @context.try(:pusher).present?
    end

    def release_request_event?
      @context.try(:action) == "released"
    end
  end
end

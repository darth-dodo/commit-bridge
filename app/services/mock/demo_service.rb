module Mock
  class DemoService < ApplicationService
    #     validation errors
    #     payload = {"no_event": 123, "user_data": nil}
    #     service_instance = Mock::DemoService.new(payload)
    #     service_instance.validate
    #     service_instance.errors
    #
    #     direct execution with validation errors
    #     service_instance = Mock::DemoService.new(payload)
    #     service_instance.execute
    #     service_instance.errors
    #
    #     explode the service
    #     service_instance = Mock::DemoService.new(payload)
    #     service_instance.execute!
    #
    #
    #     execution errors
    #     payload = {"event": 123, "user_data": "yes", "no_complex_logic": true}
    #     service_instance = Mock::DemoService.new(payload)
    #     service_instance.validate
    #     service_instance.valid
    #     service_instance.execute
    #     service_instance.errors
    #
    #     explode the service after execution
    #     service_instance = Mock::DemoService.new(payload)
    #     service_instance.execute!
    #
    def initialize(context)
      super()
      @context = Hashie::Mash.new(context)
      @event = @context.event
      @user_data = @context.user_data
      @no_complex_logic = @context.no_complex_logic
    end

    def validate
      puts "running demo validate"
      error('Event must be present') if @event.blank?
      # error('User details must be present') if @user_data.blank?
      # validate_some_complicated_logic
      super()
      valid?
    end

    def execute
      puts "running demo execute"
      super()
      return false unless valid?
      puts "Executing for user data"
      # event_commit_creation
      @service_response_data = @context
      valid?
    end

    private

    def validate_some_complicated_logic
      error("this is some more complicated logic validation error") unless @no_complex_logic
    end

    def event_commit_creation
      new_event_commit = EventCommit.new
      unless new_event_commit.save
        error(new_event_commit.errors.full_messages)
      end
    end
  end
end

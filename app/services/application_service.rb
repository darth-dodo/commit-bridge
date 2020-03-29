class ApplicationService
  # Base Application Layer Service
  attr_reader :errors, :valid, :service_response_data

  def initialize
    @errors = []
    @valid = nil
    @ran_validations = false
    @service_response_data = {}
  end

  def validate
    puts "running base service validate"
    @ran_validations = true
    valid?
  end

  def execute
    puts "running base service execute"
    unless @ran_validations
      validate
    end
    valid?
  end

  def execute!
    puts "running super execute!"
    unless execute
      raise StandardError, error_messages
    end
  end

  private

  def error(error_message)
    if error_message.is_a?(Array)
      @errors.concat(error_message)
    elsif error_message.is_a?(String)
      @errors << error_message
    end
  end

  def error_messages
    @errors.join(', ')
  end

  def valid?
    @valid = @errors.blank?
    unless @valid
      @service_response_data = { errors: error_messages }
      @valid = false
    end
    @valid
  end
end

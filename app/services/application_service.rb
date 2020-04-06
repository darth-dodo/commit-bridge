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
    @ran_validations = true
    valid?
  end

  def execute
    unless @ran_validations
      validate
    end
    valid?
  end

  def execute!
    unless execute
      raise CommitBridgeExceptions::CommitBridgeValidationError, @errors
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

  def raise_rollback_unless_valid
    unless valid?
      puts "Rolling back the transaction!"
      raise ActiveRecord::Rollback
    end
  end
end

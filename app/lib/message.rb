class Message
  def self.invalid_credentials
    'Invalid credentials!'
  end

  def self.default_error_message
    'Something went wrong!'
  end

  def self.not_found(record = 'record')
    "Sorry, #{record} not found"
  end
end

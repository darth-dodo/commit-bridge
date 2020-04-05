class ApiClient < ApplicationRecord
  has_secure_token :api_key
  # associations

  # validations
  before_validation :extend_expiry, if: :new_record_or_api_key_changed?

  # scopes

  # class methods

  # instance methods

  # validation methods

  # callbacks
  def new_record_or_api_key_changed?
    new_record? || api_key_changed?
  end

  def extend_expiry
    self.expiry = Time.now + 2.week
  end
end

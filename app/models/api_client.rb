# == Schema Information
#
# Table name: api_clients
#
#  id          :bigint           not null, primary key
#  api_key     :string           not null
#  code        :string
#  description :text
#  expiry      :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_api_clients_on_api_key  (api_key)
#
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

  def api_key_expired?
    expiry < Time.now
  end
end

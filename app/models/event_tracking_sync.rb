class EventTrackingSync < ApplicationRecord
  #enums
  enum status: {
      pending: 0,
      failed: 1,
      success: 2,
  }

  # associations
  belongs_to :event

  # validations
  validates_uniqueness_of :event_id
  validates_presence_of :event, :status

  # scopes

  # class methods

  # instance methods

  # validation methods

  # callbacks
end

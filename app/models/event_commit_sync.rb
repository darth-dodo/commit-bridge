class EventCommitSync < ApplicationRecord
  # enums
  enum status: {
      pending: 0,
      failed: 1,
      successful: 2,
  }
  # associations
  belongs_to :event_commit

  # validations


  # class methods

  # instance methods

  # callbacks

end


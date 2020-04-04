class EventTicket < ApplicationRecord
  # associations
  belongs_to :event
  belongs_to :ticket

  # validations
  validates_presence_of :event, :ticket
  validates_uniqueness_of :ticket, scope: :event, message: "is already attached to the event!"
  # scopes

  # class methods

  # instance methods

  # callbacks
end

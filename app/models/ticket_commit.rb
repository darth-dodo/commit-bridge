class TicketCommit < ApplicationRecord
  # associations
  belongs_to :ticket
  belongs_to :commit

  validates_presence_of :ticket, :commit

  # validations

  # class methods

  # instance methods

  # callbacks
end

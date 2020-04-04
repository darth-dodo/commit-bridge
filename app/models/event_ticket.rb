# == Schema Information
#
# Table name: event_tickets
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  ticket_id  :bigint           not null
#
# Indexes
#
#  index_event_tickets_on_event_id   (event_id)
#  index_event_tickets_on_ticket_id  (ticket_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (ticket_id => tickets.id)
#
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

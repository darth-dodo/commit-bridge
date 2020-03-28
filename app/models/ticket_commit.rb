# == Schema Information
#
# Table name: ticket_commits
#
#  id         :bigint           not null, primary key
#  ticket_id  :bigint           not null
#  commit_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (ticket_id => tickets.id)
#
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

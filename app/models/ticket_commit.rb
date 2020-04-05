# == Schema Information
#
# Table name: ticket_commits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  commit_id  :bigint           not null
#  ticket_id  :bigint           not null
#
# Indexes
#
#  index_ticket_commits_on_commit_id  (commit_id)
#  index_ticket_commits_on_ticket_id  (ticket_id)
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
  validates_uniqueness_of :ticket_id, scope: :commit_id,
                          message: "cannot be attached to the same commit more than once!"

  # validations

  # class methods

  # instance methods

  # callbacks
end

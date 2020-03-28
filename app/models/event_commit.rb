# == Schema Information
#
# Table name: event_commits
#
#  id         :bigint           not null, primary key
#  commit_id  :bigint           not null
#  event_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (event_id => events.id)
#
class EventCommit < ApplicationRecord
  # associations
  belongs_to :event
  belongs_to :commit

  # validations
  validates_presence_of :event, :commit

  # scopes

  # class methods

  # instance methods

  # callbacks
end

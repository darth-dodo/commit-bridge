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
class EventCommit < ApplicationRecord
  belongs_to :event
  belongs_to :commit

  validates_presence_of :event, :commit
end

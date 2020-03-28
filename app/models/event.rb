# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_type      :integer          not null
#  event_timestamp :datetime         not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Event < ApplicationRecord
  # enums
  enum event_type: {
    pull: 0,
    push: 1,
    release: 2,
  }

  # associations
  has_many :event_commits
  has_many :commits, through: :event_commits

  # validations
  validates_presence_of :event_type, :event_timestamp

  # class methods

  # instance methods

  # signals
end

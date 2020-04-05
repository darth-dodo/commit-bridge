# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_timestamp :datetime         not null
#  event_type      :integer          not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repository_id   :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_events_on_repository_id  (repository_id)
#  index_events_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  # enums
  enum event_type: {
    pull_request: 0,
    push_request: 1,
    release: 2,
  }

  # associations
  belongs_to :repository
  belongs_to :user
  has_one :release

  has_many :event_commits
  has_many :commits, through: :event_commits

  has_many :event_tickets
  has_many :tickets, through: :event_tickets

  # validations
  validates_presence_of :event_type, :event_timestamp
  validates_uniqueness_of :payload, scope: :event_type, message: "present across existing event of the same type!"

  # class methods

  # instance methods

  # callbacks
end

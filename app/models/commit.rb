# == Schema Information
#
# Table name: commits
#
#  id               :bigint           not null, primary key
#  commit_timestamp :datetime         not null
#  message          :string           not null
#  sha              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  release_id       :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_commits_on_release_id  (release_id)
#  index_commits_on_sha         (sha) UNIQUE
#  index_commits_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (release_id => releases.id)
#  fk_rails_...  (user_id => users.id)
#
class Commit < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :release, optional: true

  has_many :event_commits
  has_many :events, through: :event_commits

  has_many :ticket_commits
  has_many :tickets, through: :ticket_commits

  # validations
  validates_presence_of :message, :commit_timestamp, :sha
  validates_uniqueness_of :sha

  # scopes

  # class methods

  # instance methods

  # callbacks
end

# == Schema Information
#
# Table name: commits
#
#  id               :bigint           not null, primary key
#  message          :string           not null
#  sha              :string           not null
#  commit_timestamp :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#  release_id       :bigint
#
# Foreign Keys
#
#  fk_rails_...  (release_id => releases.id)
#  fk_rails_...  (user_id => users.id)
#
class Commit < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :release

  has_many :event_commits
  has_many :events, through: :event_commits

  has_many :ticket_commits
  has_many :tickets, through: :ticket_commits

  # validations
  validates_presence_of :message, :commit_timestamp, :sha

  # scopes

  # class methods

  # instance methods

  # callbacks
end

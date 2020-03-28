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
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Commit < ApplicationRecord
  belongs_to :user

  has_many :event_commits
  has_many :events, through: :event_commits

  has_many :ticket_commits
  has_many :tickets, through: :ticket_commits

  validates_presence_of :message, :commit_timestamp, :sha
end

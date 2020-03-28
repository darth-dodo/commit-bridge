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
#
class Commit < ApplicationRecord
  has_many :event_commits
  has_many :events, through: :event_commits

  validates_presence_of :message, :commit_timestamp, :sha
end

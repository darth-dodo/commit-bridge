# == Schema Information
#
# Table name: releases
#
#  id             :bigint           not null, primary key
#  tag            :string           not null
#  application_id :integer          not null
#  released_at    :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :bigint
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Release < ApplicationRecord
  # associations
  has_many :commits
  belongs_to :event

  # validations
  validates_presence_of :application_id, :tag, :released_at
  validate :release_event?

  # scopes

  # class methods

  # instance methods

  # validation methods
  def release_event?
    unless event.release?
      errors << "Associated Event should be a Release Event"
    end
  end
  # callbacks
end

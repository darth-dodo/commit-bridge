# == Schema Information
#
# Table name: releases
#
#  id             :bigint           not null, primary key
#  released_at    :datetime         not null
#  tag            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :integer          not null
#  event_id       :bigint
#
# Indexes
#
#  index_releases_on_event_id  (event_id)
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
  validates_presence_of :application_id, :tag, :released_at, :event
  validate :release_event?

  # scopes

  # class methods

  # instance methods

  # validation methods
  def release_event?
    if event.blank?
      errors.add(:base, "Release should be attached to an Event!")
      return
    end

    unless event.release?
      errors.add(:base, "Associated Event should be a Release Event")
    end
  end
  # callbacks
end

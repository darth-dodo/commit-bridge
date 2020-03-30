# == Schema Information
#
# Table name: repositories
#
#  id             :bigint           not null, primary key
#  application_id :integer          not null
#  slug           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Repository < ApplicationRecord
  # associations
  has_many :events

  # validations
  validates_presence_of :application_id, :slug
  validates_uniqueness_of :application_id, :slug
  validates_numericality_of :application_id

  # scopes

  # class methods

  # instance methods

  # callbacks
end

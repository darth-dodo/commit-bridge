# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  application_id :integer          not null
#  name           :string           not null
#  email          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class User < ApplicationRecord
  # associations
  has_many :commits
  has_many :events

  # validations
  validates_presence_of :application_id, :email, :name
  validates_uniqueness_of :application_id, :email
  validates_numericality_of :application_id
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # scopes

  # class methods
  def self.human_attribute_name(attr, options = {})
    attr == :application_id ? 'Application ID' : super
  end

  # instance methods

  # callbacks
end

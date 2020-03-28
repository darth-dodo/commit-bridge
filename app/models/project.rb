# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text
#  code        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Project < ApplicationRecord
  # associations
  has_many :tickets

  # validations
  validates_presence_of :code

  # scopes

  # class methods

  # instance methods

  # callbacks
end

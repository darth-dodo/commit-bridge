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

  # scopes

  # class methods

  # instance methods

  # callbacks
end

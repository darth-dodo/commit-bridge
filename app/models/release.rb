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
#
class Release < ApplicationRecord
  # associations
  has_many :commits

  # validations
  validates_presence_of :application_id, :tag, :released_at

  # scopes

  # class methods

  # instance methods

  # callbacks
end

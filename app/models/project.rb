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

class Ticket < ApplicationRecord
  # associations
  belongs_to :project

  # validations
  validates_presence_of :code, :project
  validates_uniqueness_of :code, scope: :project

  # scopes

  # class methods

  # instance methods

  # callbacks
end

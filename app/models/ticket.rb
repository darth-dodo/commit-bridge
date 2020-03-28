class Ticket < ApplicationRecord
  # associations
  belongs_to :project

  has_many :ticket_commits
  has_many :commits, through: :ticket_commits

  # validations
  validates_presence_of :code, :project
  validates_uniqueness_of :code, scope: :project

  # scopes

  # class methods

  # instance methods

  # callbacks
end

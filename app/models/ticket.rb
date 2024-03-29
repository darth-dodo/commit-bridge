# == Schema Information
#
# Table name: tickets
#
#  id          :bigint           not null, primary key
#  code        :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#
# Indexes
#
#  index_tickets_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Ticket < ApplicationRecord
  # associations
  belongs_to :project

  has_many :ticket_commits
  has_many :commits, through: :ticket_commits

  has_many :event_tickets
  has_many :events, through: :event_tickets

  # validations
  validates_presence_of :code, :project
  validates_uniqueness_of :code, scope: :project_id

  # scopes

  # class methods

  # instance methods
  def hash_code
    "\##{project.code}-#{code}"
  end

  # callbacks
end

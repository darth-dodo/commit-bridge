# == Schema Information
#
# Table name: tickets
#
#  id          :bigint           not null, primary key
#  description :text
#  code        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
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

  # validations
  validates_presence_of :code, :project
  validates_uniqueness_of :code, scope: :project

  # scopes

  # class methods

  # instance methods

  # callbacks
end

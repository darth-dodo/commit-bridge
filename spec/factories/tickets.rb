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
FactoryBot.define do
  factory :ticket do
    code { Faker::Number.number(digits: 3) }
    association :project
  end
end

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
FactoryBot.define do
  factory :ticket do
  end
end

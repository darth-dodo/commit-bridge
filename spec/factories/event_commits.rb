# == Schema Information
#
# Table name: event_commits
#
#  id         :bigint           not null, primary key
#  commit_id  :bigint           not null
#  event_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_commit do
  end
end

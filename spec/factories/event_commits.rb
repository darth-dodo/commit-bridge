# == Schema Information
#
# Table name: event_commits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  commit_id  :bigint           not null
#  event_id   :bigint           not null
#
# Indexes
#
#  index_event_commits_on_commit_id  (commit_id)
#  index_event_commits_on_event_id   (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_commit do
    association :event
    association :commit
  end
end

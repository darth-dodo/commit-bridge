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
FactoryBot.define do
  factory :event_commit do
  end
end

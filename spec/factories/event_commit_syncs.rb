# == Schema Information
#
# Table name: event_commit_syncs
#
#  id               :bigint           not null, primary key
#  response_payload :jsonb            not null
#  status           :integer          not null
#  sync_timestamp   :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  event_commit_id  :bigint           not null
#
# Indexes
#
#  index_event_commit_syncs_on_event_commit_id  (event_commit_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_commit_id => event_commits.id)
#
FactoryBot.define do
  factory :event_commit_sync do
    status { :pending }
    sync_timestamp { Time.now }
    association :event_commit

    trait :sync_pending do
      status { :pending }
    end

    trait :sync_failed do
      status { :failed }
      response_payload { JSON.parse(File.read("spec/fixtures/event_commit_failed_sync_paylaod.json")) }
    end

    trait :sync_successful do
      status { :successful }
      response_payload { JSON.parse(File.read("spec/fixtures/event_commit_successful_sync_payload.json")) }
    end

    factory :pending_event_commit_sync, traits: [:sync_pending]
    factory :failed_event_commit_sync, traits: [:sync_failed]
    factory :successful_event_commit_sync, traits: [:sync_successful]
  end
end

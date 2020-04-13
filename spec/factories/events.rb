# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_timestamp :datetime         not null
#  event_type      :integer          not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repository_id   :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_events_on_repository_id  (repository_id)
#  index_events_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :event do
    event_timestamp { Time.now }
    event_type { :pull_request }
    payload { JSON.parse(File.read("spec/fixtures/pull_request_payload.json")) }
    association :repository
    association :user

    trait :pull_request_payload do
      payload { JSON.parse(File.read("spec/fixtures/pull_request_payload.json")) }
    end

    trait :push_request_payload do
      event_type { :push_request }
      payload { JSON.parse(File.read("spec/fixtures/push_request_payload.json")) }
    end

    trait :release_request_payload do
      event_type { :release }
      payload { JSON.parse(File.read("spec/fixtures/release_request_payload.json")) }
    end

    factory :pull_request_event, traits: [:pull_request_payload]
    factory :push_request_event, traits: [:push_request_payload]
    factory :release_request_event, traits: [:release_request_payload]
  end
end

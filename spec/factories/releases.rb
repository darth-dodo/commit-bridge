# == Schema Information
#
# Table name: releases
#
#  id             :bigint           not null, primary key
#  released_at    :datetime         not null
#  tag            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :integer          not null
#  event_id       :bigint
#
# Indexes
#
#  index_releases_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :release do
    tag { Faker::App.semantic_version }
    application_id { Faker::Number.number(digits: 5) }
    released_at { Time.now }
    association :event, factory: :release_request_event
  end
end

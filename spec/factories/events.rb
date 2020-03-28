# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_type      :integer          not null
#  event_timestamp :datetime         not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :event do
  end
end

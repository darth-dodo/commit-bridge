# == Schema Information
#
# Table name: api_clients
#
#  id          :bigint           not null, primary key
#  api_key     :string           not null
#  code        :string
#  description :text
#  expiry      :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_api_clients_on_api_key  (api_key)
#
FactoryBot.define do
  factory :api_client do
    code { Faker::Name.initials }

    factory :api_client_with_expired_key do
      after(:create) do |api_client|
        api_client.expiry = Faker::Date.between(from: 20.days.ago, to: 1.days.ago)
      end
    end
  end
end

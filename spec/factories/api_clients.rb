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
  end
end

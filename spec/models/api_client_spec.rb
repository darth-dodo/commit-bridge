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
require 'rails_helper'

RSpec.describe(ApiClient, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end

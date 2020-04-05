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
  context "ApiClient creation" do
    it "should check new records have API key and Expiry" do
      api_client = create(:api_client)
      expect(api_client.api_key.present?).to(eq(true))
      expect(api_client.expiry.present?).to(eq(true))
    end

    it "should make sure the API key is expired after two weeks" do
      api_client = create(:api_client)
      Timecop.freeze(Date.today + 15.day) do
        expect(api_client.api_key_expired?).to(eq(true))
      end
    end
  end

  context "ApiClient updation" do
    it "should confirm that the API key has been regenerated" do
      api_client = create(:api_client)
      original_key = api_client.api_key
      api_client.regenerate_api_key
      expect(api_client.api_key).not_to(eq(original_key))
    end

    it "should confirm that the API expiry has been extended" do
      api_client = create(:api_client)
      original_expiry_timestamp = api_client.expiry
      Timecop.freeze(Date.today + 15.day) do
        api_client.regenerate_api_key
        expect(api_client.expiry).not_to(eq(original_expiry_timestamp))
      end
    end
  end
end

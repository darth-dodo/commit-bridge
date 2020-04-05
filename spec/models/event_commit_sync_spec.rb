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
require 'rails_helper'

RSpec.describe(EventCommitSync, type: :model) do
  describe "Model Validations" do
    it { should define_enum_for(:status) }
    it { should validate_presence_of(:event_commit_id) }
    it { should validate_presence_of(:status) }
  end

  describe "Uniqueness Validations" do
    subject { create(:failed_event_commit_sync) }
    it { should validate_uniqueness_of(:event_commit_id) }
  end

  describe "Model Associations" do
    it { should belong_to(:event_commit) }
  end
end

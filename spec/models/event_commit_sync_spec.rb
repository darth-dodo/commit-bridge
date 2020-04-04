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
  pending "add some examples to (or delete) #{__FILE__}"
end

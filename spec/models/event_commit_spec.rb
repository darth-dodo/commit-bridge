# == Schema Information
#
# Table name: event_commits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  commit_id  :bigint           not null
#  event_id   :bigint           not null
#
# Indexes
#
#  index_event_commits_on_commit_id  (commit_id)
#  index_event_commits_on_event_id   (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe(EventCommit, type: :model) do
  # describe "Model Validations" do
  #   it { should validate_presence_of(:commit) }
  #   it { should validate_presence_of(:event) }
  # end

  describe "Uniqueness Validations" do
    # subject{create(:event_commit, event: create(:event), commit: create(:commit))}
    subject { create(:event_commit) }
    it { should validate_uniqueness_of(:commit_id).scoped_to(:event_id) }
  end

  describe "Model Associations" do
    it { should belong_to(:event) }
    it { should belong_to(:commit) }
    it { should have_one(:event_commit_sync) }
  end
end

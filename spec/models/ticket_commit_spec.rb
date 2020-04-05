# == Schema Information
#
# Table name: ticket_commits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  commit_id  :bigint           not null
#  ticket_id  :bigint           not null
#
# Indexes
#
#  index_ticket_commits_on_commit_id  (commit_id)
#  index_ticket_commits_on_ticket_id  (ticket_id)
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (ticket_id => tickets.id)
#
require 'rails_helper'

RSpec.describe(TicketCommit, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:ticket) }
    it { should validate_presence_of(:commit) }
  end

  describe "Uniqueness Validations" do
    subject { create(:ticket_commit) }
    it {
      should validate_uniqueness_of(:ticket_id)
        .scoped_to(:commit_id)
        .with_message("cannot be attached to the same commit more than once!")
    }
  end

  describe "Model Associations" do
    it { should belong_to(:ticket) }
    it { should belong_to(:commit) }
  end
end

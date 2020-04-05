# == Schema Information
#
# Table name: commits
#
#  id               :bigint           not null, primary key
#  commit_timestamp :datetime         not null
#  commit_type      :integer          not null
#  message          :string           not null
#  sha              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  release_id       :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_commits_on_release_id  (release_id)
#  index_commits_on_sha         (sha) UNIQUE
#  index_commits_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (release_id => releases.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe(Commit, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:commit_timestamp) }
    it { should validate_presence_of(:sha) }
    it { should define_enum_for(:commit_type) }
  end

  # https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda/matchers/active_record/validate_uniqueness_of_matcher.rb#L56
  describe "Uniqueness Validations" do
    subject { create(:commit) }
    it { should validate_uniqueness_of(:sha) }
  end

  describe "Model Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:release) }

    it { should have_many(:event_commits) }
    it { should have_many(:events).through(:event_commits) }

    it { should have_many(:ticket_commits) }
    it { should have_many(:tickets).through(:ticket_commits) }
  end
end

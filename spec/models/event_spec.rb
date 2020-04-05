# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_timestamp :datetime         not null
#  event_type      :integer          not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repository_id   :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_events_on_repository_id  (repository_id)
#  index_events_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe(Event, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:event_type) }
    it { should validate_presence_of(:event_timestamp) }
  end

  # https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda/matchers/active_record/validate_uniqueness_of_matcher.rb#L56
  describe "Uniqueness Validations" do
    pull_request_fixture_data = JSON.parse(File.read("spec/fixtures/pull_request_payload.json"))

    subject { create(:event, payload: pull_request_fixture_data) }
    it {
      should validate_uniqueness_of(:payload)
        .scoped_to(:event_type)
        .with_message("present across existing event of the same type!")
    }
  end

  describe "Model Associations" do
    it { should belong_to(:repository) }
    it { should belong_to(:user) }
    it { should have_one(:release) }

    it { should have_many(:event_commits) }
    it { should have_many(:commits).through(:event_commits) }

    it { should have_many(:event_tickets) }
    it { should have_many(:tickets).through(:event_tickets) }
  end
end

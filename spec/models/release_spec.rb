# == Schema Information
#
# Table name: releases
#
#  id             :bigint           not null, primary key
#  released_at    :datetime         not null
#  tag            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :integer          not null
#  event_id       :bigint
#
# Indexes
#
#  index_releases_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe(Release, type: :model) do
  describe "Model Validations" do
    let(:release_event) { create(:release_request_event) }
    let(:release) { create(:release, event: release_event) }
    it "should the validations" do
      subject { :release }
      should validate_presence_of(:application_id)
      should validate_presence_of(:event)
      should validate_presence_of(:tag)
      should validate_presence_of(:released_at)
    end
  end

  describe "Model Associations" do
    it { should belong_to(:event) }
    it { should have_many(:commits) }
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id          :bigint           not null, primary key
#  code        :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#
# Indexes
#
#  index_tickets_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require 'rails_helper'

RSpec.describe(Ticket, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:project) }
  end

  describe "Uniqueness Validations" do
    subject { create(:ticket) }
    it { should validate_uniqueness_of(:code).scoped_to(:project_id) }
  end

  describe "Model Associations" do
    it { should belong_to(:project) }

    it { should have_many(:ticket_commits) }
    it { should have_many(:commits).through(:ticket_commits) }

    it { should have_many(:event_tickets) }
    it { should have_many(:events).through(:event_tickets) }
  end

  describe "Instance methods" do
    let(:demo_project) { create(:project, code: "DEMO") }
    let(:instance_method_ticket) { create(:ticket, project: demo_project, code: 123) }

    it "should validate hash code structure" do
      expect(instance_method_ticket.hash_code).to(eq("#DEMO-123"))
    end
  end
end

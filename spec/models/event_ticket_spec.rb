# == Schema Information
#
# Table name: event_tickets
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  ticket_id  :bigint           not null
#
# Indexes
#
#  index_event_tickets_on_event_id   (event_id)
#  index_event_tickets_on_ticket_id  (ticket_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (ticket_id => tickets.id)
#
require 'rails_helper'

RSpec.describe(EventTicket, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:ticket) }
  end

  describe "Uniqueness Validations" do
    subject { create(:event_ticket) }
    it {
      should validate_uniqueness_of(:ticket_id)
        .scoped_to(:event_id)
        .with_message("is already attached to the event!")
    }
  end

  describe "Model Associations" do
    it { should belong_to(:event) }
    it { should belong_to(:ticket) }
  end
end

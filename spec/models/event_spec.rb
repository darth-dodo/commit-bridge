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
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  event_type      :integer          not null
#  event_timestamp :datetime         not null
#  payload         :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#  repository_id   :bigint
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

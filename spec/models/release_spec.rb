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
  pending "add some examples to (or delete) #{__FILE__}"
end

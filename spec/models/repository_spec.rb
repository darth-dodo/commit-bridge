# == Schema Information
#
# Table name: repositories
#
#  id             :bigint           not null, primary key
#  application_id :integer          not null
#  slug           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe(Repository, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end

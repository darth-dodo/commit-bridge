# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  application_id :integer          not null
#  name           :string           not null
#  email          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe(User, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end

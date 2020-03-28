# == Schema Information
#
# Table name: commits
#
#  id               :bigint           not null, primary key
#  message          :string           not null
#  sha              :string           not null
#  commit_timestamp :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe(Commit, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end

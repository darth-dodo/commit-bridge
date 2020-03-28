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
FactoryBot.define do
  factory :commit do
  end
end

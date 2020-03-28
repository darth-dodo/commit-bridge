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
FactoryBot.define do
  factory :repository do
  end
end

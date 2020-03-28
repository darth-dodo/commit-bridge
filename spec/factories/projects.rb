# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text
#  code        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :project do
  end
end

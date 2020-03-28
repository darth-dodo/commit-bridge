# == Schema Information
#
# Table name: releases
#
#  id             :bigint           not null, primary key
#  tag            :string           not null
#  application_id :integer          not null
#  released_at    :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :release do
  end
end

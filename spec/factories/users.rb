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
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: :name) }
    application_id { Faker::Number.number(digits: 5) }
  end

  factory :user_with_event_and_commits do
    after(:create) do |user|
      create(:commit, user: user)
      create(:event, user: user)
    end
  end
end

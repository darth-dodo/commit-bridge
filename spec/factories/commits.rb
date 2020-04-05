# == Schema Information
#
# Table name: commits
#
#  id               :bigint           not null, primary key
#  commit_timestamp :datetime         not null
#  commit_type      :integer          not null
#  message          :string           not null
#  sha              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  release_id       :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_commits_on_release_id  (release_id)
#  index_commits_on_sha         (sha) UNIQUE
#  index_commits_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (release_id => releases.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :commit do
    sha { Faker::Crypto.sha1 }
    message { Faker::Movies::StarWars.quote }
    commit_timestamp { Time.now }
    commit_type { :fix }
    association :user
  end
end

# == Schema Information
#
# Table name: ticket_commits
#
#  id         :bigint           not null, primary key
#  ticket_id  :bigint           not null
#  commit_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (commit_id => commits.id)
#  fk_rails_...  (ticket_id => tickets.id)
#
FactoryBot.define do
  factory :ticket_commit do
  end
end

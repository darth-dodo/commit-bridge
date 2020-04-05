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
  describe "Model Validations" do
    it { should validate_presence_of(:application_id) }
    it { should validate_presence_of(:slug) }
    it { should validate_numericality_of(:application_id) }
  end

  describe "Uniqueness Validations" do
    subject { create(:repository) }
  end

  describe "Model Associations" do
    it { should have_many(:events) }
  end
end

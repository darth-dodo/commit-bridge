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
  describe "Model Validations" do
    it { should validate_presence_of(:application_id) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:application_id) }
  end

  describe "Uniqueness Validations" do
    subject { create(:user) }
    it { should validate_uniqueness_of(:application_id) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "Model Associations" do
    it { should have_many(:commits) }
    it { should have_many(:events) }
  end
end

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
require 'rails_helper'

RSpec.describe(Project, type: :model) do
  describe "Model Validations" do
    it { should validate_presence_of(:code) }
  end

  describe "Model Associations" do
    it { should have_many(:tickets) }
  end
end

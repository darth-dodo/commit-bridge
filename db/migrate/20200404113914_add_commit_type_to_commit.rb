class AddCommitTypeToCommit < ActiveRecord::Migration[5.2]
  def change
    add_column(:commits, :commit_type, :integer, null: false)
  end
end

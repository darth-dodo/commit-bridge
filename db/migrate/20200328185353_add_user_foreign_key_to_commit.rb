class AddUserForeignKeyToCommit < ActiveRecord::Migration[5.2]
  def change
    add_reference(:commits, :user, index: true, foreign_key: true, null: false)
  end
end

class AddReleaseForeignKeyToCommit < ActiveRecord::Migration[5.2]
  def change
    add_reference(:commits, :release, index: true, foreign_key: true)
  end
end

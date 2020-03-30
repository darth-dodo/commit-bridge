class AddUniqueIndexForSha < ActiveRecord::Migration[5.2]
  def change
    add_index(:commits, :sha, unique: true)
  end
end

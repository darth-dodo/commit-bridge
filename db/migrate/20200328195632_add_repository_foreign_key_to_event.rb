class AddRepositoryForeignKeyToEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference(:events, :repository, index: true, foreign_key: true)
  end
end

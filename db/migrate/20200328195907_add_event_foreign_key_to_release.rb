class AddEventForeignKeyToRelease < ActiveRecord::Migration[5.2]
  def change
    add_reference(:releases, :event, index: true, foreign_key: true, unique: true)
  end
end

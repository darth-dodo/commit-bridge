class CreateReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :releases do |t|
      t.string(:tag, null: false)
      t.integer(:application_id, null: false)
      t.timestamp(:released_at, null: false)
      t.timestamps
    end
  end
end

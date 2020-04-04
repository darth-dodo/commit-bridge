class CreateEventTrackingSyncs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_tracking_syncs do |t|
      t.integer(:status, null: false)
      t.jsonb(:payload, null: false, default: '{}')
      t.references(:event, index: true, null: false, foreign_key: true, unique: true)
      t.timestamp(:last_tried)

      t.timestamps
    end
  end
end

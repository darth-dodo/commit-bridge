class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer(:event_type, null: false)
      t.timestamp(:event_timestamp, null: false)
      t.jsonb(:payload, null: false, default: '{}')

      t.timestamps
    end
  end
end

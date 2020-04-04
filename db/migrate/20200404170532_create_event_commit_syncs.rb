class CreateEventCommitSyncs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_commit_syncs do |t|
      t.references(:event_commit, index: true, null: false, foreign_key: true, unique: true)
      t.integer(:status, null: false)
      t.timestamp(:sync_timestamp)
      t.jsonb(:response_payload, null: false, default: '{}')

      t.timestamps
    end
  end
end

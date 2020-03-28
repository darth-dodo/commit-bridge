class CreateEventCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :event_commits do |t|
      t.references(:commit, index: true, null: false, foreign_key: true)
      t.references(:event, index: true, null: false, foreign_key: true)
      t.timestamps
    end
  end
end

class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.string(:message, null: false)
      t.string(:sha, null: false)
      t.timestamp(:commit_timestamp, null: false)
      t.timestamps
    end
  end
end

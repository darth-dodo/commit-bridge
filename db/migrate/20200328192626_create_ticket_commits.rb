class CreateTicketCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_commits do |t|
      t.references(:ticket, index: true, null: false, foreign_key: true)
      t.references(:commit, index: true, null: false, foreign_key: true)

      t.timestamps
    end
  end
end

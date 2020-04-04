class CreateEventTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :event_tickets do |t|
      t.references(:ticket, index: true, null: false, foreign_key: true)
      t.references(:event, index: true, null: false, foreign_key: true)

      t.timestamps
    end
  end
end

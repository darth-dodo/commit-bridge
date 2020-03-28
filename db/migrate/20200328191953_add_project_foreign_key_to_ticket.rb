class AddProjectForeignKeyToTicket < ActiveRecord::Migration[5.2]
  def change
    add_reference(:tickets, :project, index: true, foreign_key: true, null: false)
  end
end

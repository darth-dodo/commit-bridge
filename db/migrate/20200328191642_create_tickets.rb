class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.text(:description)
      t.integer(:code)
      t.timestamps
    end
  end
end

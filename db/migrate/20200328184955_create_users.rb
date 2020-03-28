class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer(:application_id, null: false)
      t.string(:name, null: false)
      t.string(:email, null: false)
      t.timestamps
    end
  end
end

class CreateApiClients < ActiveRecord::Migration[5.2]
  def change
    create_table :api_clients do |t|
      t.string(:code)
      t.text(:description)
      t.string(:api_key, null: false, unique: true, index: true)
      t.timestamp(:expiry, null: false)

      t.timestamps
    end
  end
end

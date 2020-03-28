class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.integer(:application_id, null: false)
      t.string(:slug, null: false)
      t.timestamps
    end
  end
end

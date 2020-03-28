class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.text(:description)
      t.string(:code, null: false)
      t.timestamps
    end
  end
end

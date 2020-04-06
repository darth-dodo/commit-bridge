ActiveAdmin.register(Commit) do
  actions :index, :show
  index do
    column :id
    column :commit_type
    column :message
    column :sha
    column :commit_timestamp
    column :user
    column :release
    column :created_at
    column :updated_at
    actions
  end
end

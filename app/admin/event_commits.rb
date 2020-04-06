ActiveAdmin.register(EventCommit) do
  actions :index, :show
  index do
    column :id
    column :commit
    column :event
    column :created_at
    column :updated_at
    actions
  end
end

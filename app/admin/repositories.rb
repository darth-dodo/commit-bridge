ActiveAdmin.register(Repository) do
  actions :index, :show
  index do
    column :id
    column :application_id
    column :slug
    column :created_at
    column :updated_at
    actions
  end
end

ActiveAdmin.register(Project) do
  actions :index, :show
  index do
    column :id
    column :code
    column :description
    column :created_at
    column :updated_at
    actions
  end
end

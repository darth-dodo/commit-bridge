ActiveAdmin.register(Ticket) do
  actions :index, :show
  index do
    column :id
    column :code
    column :description
    column :project
    column :created_at
    column :updated_at
    actions
  end
end

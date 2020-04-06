ActiveAdmin.register(User) do
  actions :index, :show
  index do
    column :id
    column :application_id
    column :name
    column :email
    column :created_at
    column :updated_at
    actions
  end
end

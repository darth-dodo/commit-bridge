ActiveAdmin.register(Event) do
  actions :index, :show
  index do
    column :id
    column :event_type
    column :repository
    column :user
    column :payload
    column :created_at
    column :updated_at
    actions
  end
end

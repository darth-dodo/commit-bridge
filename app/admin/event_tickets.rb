ActiveAdmin.register(EventTicket) do
  actions :index, :show
  index do
    column :id
    column :event
    column :ticket
    column :created_at
    column :updated_at
    actions
  end
end

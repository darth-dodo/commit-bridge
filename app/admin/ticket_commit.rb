ActiveAdmin.register(TicketCommit) do
  actions :index, :show
  index do
    column :id
    column :commit
    column :ticket
    column :created_at
    column :updated_at
    actions
  end
end

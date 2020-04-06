ActiveAdmin.register(EventCommitSync) do
  actions :index, :show
  index do
    column :id
    column :event_commit
    column :status
    column :sync_timestamp
    column :response_payload
    column :created_at
    column :updated_at
    actions
  end
end

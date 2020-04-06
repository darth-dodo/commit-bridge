ActiveAdmin.register(Release) do
  actions :index, :show
  index do
    column :id
    column :tag
    column :released_at
    column :application_id
    column :event
    column :created_at
    column :updated_at
    actions
  end
end

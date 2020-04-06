ActiveAdmin.register(ApiClient) do
  actions :index, :show
  index do
    column :id
    column :api_key
    column :code
    column :description
    column :expiry
    column :created_at
    column :updated_at
    actions
  end
end

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope :webhooks do
    post "git", to: "git_cloud_webhook#receive"
    post "ticket-tracking-echo", to: "git_cloud_webhook#echo"
  end
end

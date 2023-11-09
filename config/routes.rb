Rails.application.routes.draw do
  devise_config = ActiveAdmin::Devise.config
  devise_config[:path] = :auth
  devise_for :users, devise_config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :auth do
    get '/signup', to: 'signup#new'
    post '/signup', to: 'signup#create'
  end
end

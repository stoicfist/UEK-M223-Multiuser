Rails.application.routes.draw do
  resources :documents
  resources :templates
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "users/new"
  get "users/create"

  get "up" => "rails/health#show", as: :rails_health_check

  root "templates#index"

  namespace :admin do
    resources :users, only: %i[index edit update]
  end

  resources :users, only: [ :new, :create ]
  resources :sessions, only: [ :new, :create ]
  get    "login"  => "sessions#new"
  delete "logout" => "sessions#destroy"

  resources :templates do
    post :clone_to_document, on: :member
  end
  resources :documents do
    member do
      get :export_zip
    end
  end

  resource :account, controller: "users", only: [ :show, :edit, :update ] do
    get   :edit_password
    patch :update_password
    post  :email_change       # neue E-Mail anstossen (Bestätigungslink)
  end
  get "/email_change/confirm/:token", to: "users#confirm_email", as: :confirm_email_change
end

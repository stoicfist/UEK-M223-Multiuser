Rails.application.routes.draw do
  resources :documents
  resources :templates
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "users/new"
  get "users/create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "templates#index"

  resources :users, only: [ :new, :create ]
  resources :sessions, only: [ :new, :create ]
  get    "login"  => "sessions#new"
  delete "logout" => "sessions#destroy"

  resources :templates do
    post :clone_to_document, on: :member
  end
  resources :documents do
    get :export_zip, on: :member
  end
end

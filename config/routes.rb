# config/routes.rb
Rails.application.routes.draw do
  root "latex_templates#index"

  # Auth
  resources :users,    only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  get    "login"  => "sessions#new"
  delete "logout" => "sessions#destroy"

  # Admin
  namespace :admin do
    resources :users, only: [:index, :edit, :update] do
      member { patch :update_role }
    end
  end

  # Account / Profil
  resource :account, controller: "users", only: [:show, :edit, :update] do
    get   :edit_password
    patch :update_password
    post  :email_change
  end
  get "/email_change/confirm/:token", to: "users#confirm_email", as: :confirm_email_change

  # Kern-Modelle  ⬇️  (PLURAL!)
  resources :latex_templates do
    member do
      get  :new_document
      post :create_document
      post :clone_to_document
    end
  end

  # Weiterleitungen alter URLs → neue Ressource
  get "/templates",            to: redirect("/latex_templates")
  get "/templates/new",        to: redirect("/latex_templates/new")
  get "/templates/:id",        to: redirect { |p,_| "/latex_templates/#{p[:id]}" }
  get "/templates/%{id}/edit", to: redirect("/latex_templates/%{id}/edit")

  resources :documents do
    member { get :export_zip }
  end
end

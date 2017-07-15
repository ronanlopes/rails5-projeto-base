Rails.application.routes.draw do


  root to: 'application#index'

  #users routes
  devise_for :users, :skip => [:registrations]
	as :user do
	  get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
	  patch 'users' => 'devise/registrations#update', :as => 'user_registration'
	end
  resources :users, except: [:show], path: "/controle_de_usuarios"

  #páginas de erro
  match '/404', to: 'pages#not_found', via: :all
  match '/500', to: 'pages#internal_server_error', via: :all

end

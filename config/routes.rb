SampleApp::Application.routes.draw do
  resources :projects do
    resources :tasks do
      post 'start'
      post 'finish'
      resources :dailies, only: %i[update]
    end
    resource :task do
      post 'sort'
      post 'calculate'
    end
  end

  resources :users do
    member do
      get :following, :followers
      post :upload_image
    end
  end
  resources :sessions,      only: %i[new create destroy]

  resources :relationships, only: %i[create destroy]
  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
end

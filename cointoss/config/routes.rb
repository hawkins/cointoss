Rails.application.routes.draw do
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :users, only: [:new, :create]
    resources :rooms
    resources :actions
    resources :bets
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    get 'welcome', to: 'sessions#welcome'
    get 'authorized', to: 'sessions#page_requires_login'
    get 'logout', to: 'sessions#logout' 
    get '', to: 'sessions#welcome'
    get 'bank', to: 'sessions#bank'
    get 'I_AM_A_GREEDY_BITCH', to: 'sessions#greed'
    get 'about', to: 'sessions#about'
    post 'add_user', to: 'rooms#add_user'
    post 'remove_user', to: 'rooms#remove_user'
end

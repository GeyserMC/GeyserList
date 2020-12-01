Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/", to: "servers#index"
  resources :servers
  
  get 'login', to: 'auth#login'
  get 'login/discord', to: 'auth#discord'
  get 'login/google', to: 'auth#google'
  post 'registration/complete', to: 'auth#register'
  get 'logout', to: 'auth#logout'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/", to: "servers#index"
  get 'servers/test', to: 'servers#tester'
  post 'servers/test', to: 'servers#result'
  resources :servers
  post 'servers/:id/query', to: 'servers#requery'

  scope 'login' do
    get '', to: 'auth#login'
    get 'discord', to: 'auth#discord'
    get 'google', to: 'auth#google'
    get 'apple', to: 'auth#login_apple'
    post 'apple', to: 'auth#apple'
    get 'github', to: 'auth#github'
    get 'xbox', to: 'auth#xbox'
  end
  post 'registration/complete', to: 'auth#register'
  get 'logout', to: 'auth#logout'

  scope 'mod' do
    get 'reports', to: 'mod#reports'
    get 'users', to: 'mod#users'
    get 'log', to: 'mod#log'
  end

  get 'api/v1/server/:id', to: 'api#get_server'
end

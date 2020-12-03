Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/", to: "servers#index"
  resources :servers

  scope 'login' do
    get '', to: 'auth#login'
    get 'discord', to: 'auth#discord'
    get 'google', to: 'auth#google'
    get 'apple', to: 'auth#login_apple'
    post 'apple', to: 'auth#apple'
    get 'github', to: 'auth#github'
  end
  post 'registration/complete', to: 'auth#register'
  get 'logout', to: 'auth#logout'

  get 'api/v1/server/:id', to: 'api#get_server'
end

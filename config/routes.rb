Rails.application.routes.draw do
  get 'home/start_mining'

  get 'home/index'

  get 'start_mining', to: 'home#start_mining'

  root 'home#index'
end

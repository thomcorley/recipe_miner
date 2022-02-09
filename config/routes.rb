Rails.application.routes.draw do
  get "search/search"
  get "home/start_mining"
  get "home/index"
  get "start_mining", to: "home#start_mining"
  get "search", to: "search#search"

  root "home#index"
end

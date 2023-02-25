Rails.application.routes.draw do

  resources :foo

  root :to => "home#index"
end

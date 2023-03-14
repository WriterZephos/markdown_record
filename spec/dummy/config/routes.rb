Rails.application.routes.draw do

  resource :foo

  root :to => "home#index"
end
# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      get 'lives/ended', to: 'lives#ended'
      get 'lives/current', to: 'lives#current'
      get 'lives/scheduled', to: 'lives#scheduled'
      resources :lives
      resources :channels
      resources :members
      resources :rooms
      resources :platforms
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

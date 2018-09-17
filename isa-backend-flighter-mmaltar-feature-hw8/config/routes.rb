Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/world-cup', to: 'application#matches'

  namespace :api do
    resources :users, except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    resource :session, only: [:create, :destroy]
  end

  get '/api/statistics/flights', to: 'api/statistics#flights_index'
  get '/api/statistics/companies', to: 'api/statistics#companies_index'

end

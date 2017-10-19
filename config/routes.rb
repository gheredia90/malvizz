Rails.application.routes.draw do
  root to: 'malheur#home'
  get 'dataset', to: 'malheur#home', format: :json
  post 'malheur_import', to: 'malheur#import'
end

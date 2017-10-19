Rails.application.routes.draw do
  root to: 'malheur#home'
  post 'malheur_import', to: 'malheur#import'
end

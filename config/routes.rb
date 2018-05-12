Rails.application.routes.draw do
  
  root "main#index"
  
  get '/:id' => "main#show"
  resources :main, only: [:index, :create]
  
  match "api/truncate" => "api#truncate", via: [:get, :post]
  match "api/get" => "api#get_data", via: [:get, :post]
end

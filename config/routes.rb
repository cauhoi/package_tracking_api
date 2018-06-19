Rails.application.routes.draw do
  post 'api/v1/packages' => 'packages#create', :as => :create_package
  put 'api/v1/packages/:id' => 'packages#update', as: :update_package
  get 'api/v1/packages' => 'packages#index', as: :get_packages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

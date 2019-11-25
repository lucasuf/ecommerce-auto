Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
	root :to => "api/v1/orders#index"
	scope module: 'api/v1' do
			resources :orders
			resources :batches, param: :reference_batch
	end
end

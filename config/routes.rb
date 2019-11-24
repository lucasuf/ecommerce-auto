Rails.application.routes.draw do
	root :to => "api/v1/orders#index"
	scope module: 'api/v1' do
			resources :orders
			resources :batches, param: :reference_batch
	end
end

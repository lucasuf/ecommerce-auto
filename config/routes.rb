Rails.application.routes.draw do
	namespace 'api' do
		namespace 'v1' do
      resources :orders
      resources :batches, param: :reference_batch
		end
	end
end

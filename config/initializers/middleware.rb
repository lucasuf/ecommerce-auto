#!/usr/bin/env ruby
# http://guides.rubyonrails.org/v3.2.8/rails_on_rack.html
require 'rack'
require 'rails/all'

# Defaults are defined in railties/lib/rails/application/default_middleware_stack.rb
class Application < Rails::Application

  configure do
    middleware.use ::ActionDispatch::Flash
  end
end
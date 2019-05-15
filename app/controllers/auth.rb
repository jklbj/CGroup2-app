# frozen_string_literal: true

require 'roda'
require_relative './app'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            name: routing.params['name'],
            password: routing.params['password'])

          session[:current_account] = account
          flash[:notice] = "Welcome back #{account['name']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username and password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.on 'logout' do
        routing.get do
          session[:current_account] = nil
          routing.redirect @login_route
        end
      end
    end
  end
end

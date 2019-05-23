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
          
          SecureSession.new(session).set(:current_account, account)
          flash[:notice] = "Welcome back #{account['name']}!"
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError
          flash[:error] = 'Username and password did not match our records'
          response.status = 403
          routing.redirect @login_route
        rescue StandardError => e
          puts "LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @login_route
        end
      end

      @login_route = '/auth/logout'
      routing.is 'logout' do
        routing.get do 
          SecureSession.new(seesion).delete(:current_account)
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          # GET /auth/register
          routing.get do
            view :register
          end

          # POST /auth/register
          routing.post do
            account_data = JsonRequestBody.symbolize(routing.params)
            VerifyRegistration.new(App.config).call(account_data)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect '/'
          rescue StandardError => e
            puts "ERROR CREATING ACCOUNT: #{e.inspect}"
            puts e.backtrace
            routing.redirect @register_route
          end 
        end

        # GET /auth/register/<token>
        routing.get(String) do |registration_token|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(registration_token)
          view :register_confirm,
              locals: { new_account: new_account,
                        registration_token: registration_token }
        end
      end
    end
  end
end

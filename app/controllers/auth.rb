# frozen_string_literal: true

require 'roda'
require_relative './app'
require 'googleauth'
require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    plugin :multi_route
    plugin :flash

    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          credentials = Form::LoginCredentials.call(routing.params)

          if credentials.failure?
            flash[:error] = 'Please enter both username and password'
            routing.redirect @login_route
          end

          authenticated = AuthenticateAccount.new(App.config).call(credentials)

          current_account = Account.new(
            authenticated[:account],
            authenticated[:auth_token]
          )
          
          CurrentSession.new(session).current_account = current_account

          flash[:notice] = "Welcome back #{current_account.name}!"
          routing.redirect '/'
        rescue AuthenticateAccount::NotAuthenticatedError
          flash[:error] = 'Username and password did not match our records'
          response.status = 401
          routing.redirect @login_route
        rescue StandardError => e
          puts "LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @login_route
        end
      end

      routing.is 'sso_callback' do
        # GET /auth/sso_callback
        routing.get do
          client = Signet::OAuth2::Client.new({
            client_id: App.config.GG_CLIENT_ID,
            client_secret: App.config.GG_CLIENT_SECRET,
            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
            redirect_uri: App.config.GG_REDIRECT_URL,
            code: routing.params["code"]
          })

          response = client.fetch_access_token!
          auth_token = response['access_token']

          PushGoogleCalendarToken.new(App.config).call(@current_account ,auth_token)

          flash[:notice] = "Thank you for your authorization for your google calendar!"
          routing.redirect '/'
        rescue StandardError => e
          puts "SSO LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Unexpected API Error'
          response.status = 500
          routing.redirect @login_route
        end
      end

      @logout_route = '/auth/logout'
      routing.is 'logout' do
        routing.get do 
          CurrentSession.new(session).delete
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
            registration = Form::Registration.call(routing.params)
            
            if registration.failure?
              flash[:error] = Form.validation_errors(registration)
              routing.redirect @register_route
            end

            VerifyRegistration.new(App.config).call(routing.params)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect 'check_email'
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

      routing.is 'check_email' do
        # GET /auth/check_email
        routing.get do
          view :check_email
        end
      end
    end
  end
end

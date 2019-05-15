# frozen_string_literal: true

require 'roda'
require_relative './app'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/login
        routing.get String do |username|
          if @current_account && @current_account['name'] == username
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end

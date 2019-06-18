# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module CGroup2
  # Base class for CGroup2 Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets',
                    css: ['style.css', 'sb-admin-2.min.css'],
                    js: ['jquery-easing/jquery.easing.min.js', 'sb-admin-2.min.js']
    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash

    route do |routing|
      @current_account = CurrentSession.new(session).current_account

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        google_auth_url = GetGoogleAuthUrl.new(App.config).call
       
        view 'home', locals: { current_account: @current_account, google_auth_url: google_auth_url }
      end
    end
  end
end

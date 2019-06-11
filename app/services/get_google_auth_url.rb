# frozen_string_literal: true

require 'google/api_client/client_secrets'
require 'googleauth'
 
# Returns all google url
class GetGoogleAuthUrl
    def initialize(config)
      @config = config
    end
  
    def call
      client = Signet::OAuth2::Client.new({
        client_id: @config.GG_CLIENT_ID,
        client_secret: @config.GG_CLIENT_SECRET,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
        redirect_uri: @config.GG_REDIRECT_URL
      })

      auth_uri = client.authorization_uri.to_s
    end
  end
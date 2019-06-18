# frozen_string_literal: true

require 'http'

# Push google calendar token belonging to an account
class PushGoogleCalendarToken
  def initialize(config)
    @config = config
  end

  def call(current_account, access_token)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .post("#{@config.API_URL}/calendar_events",
                    json: { access_token: access_token })

    response.code == 200 ? response.parse['data'] : nil
  end
end

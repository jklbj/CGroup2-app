# frozen_string_literal: true

require 'http'

# Returns all calendar events belonging to an account
class GetAllCalendarEvents
  def initialize(config)
    @config = config
  end

  def call(current_account)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/calendar_events")

    response.code == 200 ? response.parse['data'] : nil
  end
end

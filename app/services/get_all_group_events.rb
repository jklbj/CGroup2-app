# frozen_string_literal: true

require 'http'

# Returns all group events
class GetAllGroupEvents
  def initialize(config)
    @config = config
  end

  def call(current_account)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/group_events/all")

    response.code == 200 ? response.parse['data'] : nil
  end
end

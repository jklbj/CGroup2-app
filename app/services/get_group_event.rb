# frozen_string_literal: true

require 'http'

# Returns event belonging to an account
class GetGroupEvent
  def initialize(config)
    @config = config
  end

  def call(current_account, group_id)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/group_events/#{group_id}")

    response.code == 200 ? response.parse['data'] : nil
  end
end

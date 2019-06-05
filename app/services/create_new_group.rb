# frozen_string_literal: true

require 'http'

# Create a new configuration file for a group
class CreateNewGroup
  def initialize(config)
    @config = config
  end

  def api_url
    @config.API_URL
  end

  def call(current_account:, group_data:)
    config_url = "#{api_url}/group_events"
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .post(config_url, json: group_data)

    response.code == 201 ? response.parse : raise
  end
end

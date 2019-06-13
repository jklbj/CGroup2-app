# frozen_string_literal: true

# Service to remove member to group
class DeleteGroup
    class GroupNotDeleted < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, group_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/group_events/#{group_id}")
  
      raise GroupNotDeleted unless response.code == 200
    end
  end
  
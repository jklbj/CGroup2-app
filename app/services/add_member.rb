# frozen_string_literal: true

# Service to add member to group
class AddMember
    class MemberNotAdded < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, member:, group_id:, action:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/group_events/#{group_id}/members",
                             json: { email: member[:email] })
  
      raise MemberNotAdded unless response.code == 200
    end
  end
  
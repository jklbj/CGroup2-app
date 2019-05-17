# frozen_string_literal: true

require 'http'

module CGroup2
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(name:, password:)
      puts "ussssername: #{name}"
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { name: name, password: password })

      raise(UnauthorizedError) if response.code == 403
      raise if response.code != 200

      response.parse['attributes']
    end
  end
end

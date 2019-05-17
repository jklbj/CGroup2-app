# frozen_string_literal: true

require 'http'

module CGroup2
  # Returns an authenticated user, or nil
  class CreateAccount
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(email:, username:, password:, sex:, birth:)
      message = { email: email,
                  name: username,
                  password: password,
                  sex: sex,
                  birth: birth }

      response = HTTP.post(
        "#{@config.API_URL}/accounts/",
        json: message
      )

      raise InvalidAccount unless response.code == 201
    end
  end
end

# frozen_string_literal: true

require_relative 'form_base'

module CGroup2
  module Form
    LoginCredentials = Dry::Validation.Params do
      required(:name).filled
      required(:password).filled
    end

    Registration = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/account_details.yml')
      end

      required(:name).filled(format?: USERNAME_REGEX, min_size?: 4)
      required(:email).filled(format?: EMAIL_REGEX)
      required(:birth).filled
    end

    Passwords = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/password.yml')

        def enough_entropy?(string)
          StringSecurity.entropy(string) >= 3.0
        end
      end

      required(:password).filled
      required(:password_confirm).filled

      rule(password_entropy: [:password]) do |password|
        password.enough_entropy?
      end

      rule(passwords_match: %i[password password_confirm]) do |pass1, pass2|
        pass1.eql?(pass2)
      end
    end
  end
end

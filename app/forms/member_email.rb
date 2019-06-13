# frozen_string_literal: true

require_relative 'form_base'

module CGroup2
  module Form
    MemberEmail = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/account_details.yml')
      end

      required(:email).filled(format?: EMAIL_REGEX)
    end
  end
end

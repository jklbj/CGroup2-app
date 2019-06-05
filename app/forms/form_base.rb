# frozen_string_literal: true

require 'dry-validation'

module CGroup2
  # Form helpers
  module Form
    USERNAME_REGEX = /^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/.freeze
    EMAIL_REGEX = /@/.freeze
    FILENAME_REGEX = %r{^((?![&\/\\\{\}\|\t]).)*$}.freeze
    PATH_REGEX = /^((?![&\{\}\|\t]).)*$/.freeze

    def self.validation_errors(validation)
      validation.errors.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation)
      validation.messages.values.join('; ')
    end
  end
end

# frozen_string_literal: true

require_relative 'form_base'

module CGroup2
  module Form
    NewGroup = Dry::Validation.Params do
      required(:title).filled
      required(:description).filled
      required(:limit_number).filled
      required(:due_at).filled
      required(:event_start_at).filled
      required(:event_end_at).filled

      configure do
        config.messages_file = File.join(__dir__, 'errors/new_group.yml')
      end
    end
  end
end

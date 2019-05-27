# frozen_string_literal: true

require_relative 'calendar_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Calendar_event
    attr_reader :calendar_id, :title, :description

    def initialize(cale_info)
      @calendar_id = cale_info['attribute']['calendar_id']
      @title = cale_info['attribute']['title']
      @description = cale_info['attribure']['description']
    end
  end
end

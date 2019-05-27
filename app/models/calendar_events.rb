# frozen_string_literal: true

require_relative 'calendar_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Calendar_events
    attr_reader :all

    def initialize(calendar_list)
      @all = calendar_list.map do |cale|
        Calendar_event.new(cale)
      end
    end
  end
end

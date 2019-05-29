# frozen_string_literal: true

require_relative 'calendar_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Calendar_events
    attr_reader :all

    def initialize(calendar_list)
      @all = calendar_list.map do |cale|
        calendar_event = Calendar_event.new(cale)

        puts "date_format_transform: #{calendar_event.event_start_at}"
      
        [calendar_event.title, calendar_event.event_start_at, calendar_event.event_end_at]  
      end
    end
  end
end

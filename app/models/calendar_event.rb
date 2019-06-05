# frozen_string_literal: true

require_relative 'calendar_event'
require 'json'

module CGroup2
  # Behaviors of the currently logged in account
  class Calendar_event
    attr_reader :calendar_id, :title, :description, :event_start_at, :event_end_at

    def initialize(cale_info)
      @calendar_id = cale_info['attribute']['calendar_id']
      @title = cale_info['attribute']['title']
      @description = cale_info['attribute']['description']
      @event_start_at = date_format_transform(cale_info['attribute']['event_start_at'])
      @event_end_at = date_format_transform(cale_info['attribute']['event_end_at'])
    end

    def date_format_transform(date)
      date.gsub!(" ", "+")
      date.sub!("+", "T")
      date = date.split("++")

      date[0]
    end
  end
end

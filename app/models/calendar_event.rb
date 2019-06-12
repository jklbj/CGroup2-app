# frozen_string_literal: true

require_relative 'calendar_event'
require 'json'

module CGroup2
  # Behaviors of the currently logged in account
  class Calendar_event
    attr_reader :calendar_id, :title, :description, :event_start_at, :event_end_at, # basic info
                :account # full details

    def initialize(cale_info)
     process_attributes(cale_info['attribute'])
     process_included(cale_info['included'])
    end

    def date_format_transform(date)
      date.gsub!(" ", "+")
      date.sub!("+", "T")
      date = date.split("++")

      date[0]
    end

    private

    def process_attributes(attributes)
      @calendar_id = attributes['calendar_id']
      @title = attributes['title']
      @description = attributes['description']
      @event_start_at = date_format_transform(attributes['event_start_at'])
      @event_end_at = date_format_transform(attributes['event_end_at'])
    end

    def process_included(included)
      @account = Account.new(included['account'])
    end
  end
end

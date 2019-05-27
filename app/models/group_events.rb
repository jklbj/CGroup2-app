# frozen_string_literal: true

require_relative 'group_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Group_events
    attr_reader :all

    def initialize(group_list)
      @all = group_list.map do |grpe|
        Group_event.new(grpe)
      end
    end
  end
end

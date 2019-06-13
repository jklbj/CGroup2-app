# frozen_string_literal: true

require_relative 'group_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Group_event
    attr_reader :group_id, :title, :description, :limit_number, :due_at, :event_start_at, :event_end_at, # basic info
                :owner, :members, :policies # full details

    def initialize(grpe_info)
      process_attributes(grpe_info['attribute'])
      process_relationships(grpe_info['relationships'])
      process_policies(grpe_info['policies'])
    end
  

    def date_format_transform(date)
      date.gsub!(" ", "+")
      date.sub!("+", "T")
      date = date.split("++")

      date[0]
    end

    private

    def process_attributes(attributes)
      @group_id = attributes['group_id']
      @title = attributes['title']
      @description = attributes['description']
      @limit_number = attributes['limit_number']
      @due_at = attributes['due_at']
      @event_start_at = date_format_transform(attributes['event_start_at'])
      @event_end_at = date_format_transform(attributes['event_end_at'])
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['account'])
      puts "owner name: #{relationships['account']}"
      @members = process_members(relationships['members'])

    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_members(members)
      return nil unless members

      members.map { |account_info| Account.new(account_info)}
    end
  end
end

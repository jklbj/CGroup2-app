# frozen_string_literal: true

require_relative 'group_event'

module CGroup2
  # Behaviors of the currently logged in account
  class Group_event
    attr_reader :group_id, :title, :description, :limit_number, :due_at, :member_id

    def initialize(grpe_info)
      @group_id = grpe_info['attribute']['group_id']
      @title = grpe_info['attribute']['title']
      @description = grpe_info['attribure']['description']
      @limit_number = grpe_info['attribute']['limit_number']
      @due_at = grpe_info['attribute']['due_at']
      @member_id = grpe_info['attribute']['member_id']
    end
  end
end

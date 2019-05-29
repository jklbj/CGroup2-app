# frozen_string_literal: true

require 'roda'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('group_events') do |routing|
      routing.on do
        # GET /group_events/
        routing.get do
          if @current_account.logged_in?
            group_events_list = GetAllGroupEvents.new(App.config).call(@current_account)

            group_events = Group_events.new(group_events_list)
            
            view :'group_events',
                locals: { currnet_user: @current_account, group_events: group_events }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end

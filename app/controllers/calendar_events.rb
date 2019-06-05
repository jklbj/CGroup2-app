# frozen_string_literal: true

require 'roda'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('calendar_events') do |routing|
      routing.on do
        # GET /accoounts/[account_name]/calendar_events/
        routing.get do
          if @current_account.logged_in?
            calendar_events_list = GetAllCalendarEvents.new(App.config).call(@current_account)

            calendar_events = Calendar_events.new(calendar_events_list).all
            
            view :'calendar',
                 locals: { currnet_user: @current_account, calendar_events: calendar_events }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end

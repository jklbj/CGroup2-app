# frozen_string_literal: true

require 'roda'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('group_events') do |routing|
      routing.on do
        # GET /group_events/all
        routing.get String do |grp_id|
          group_events_list = GetAllGroupEvents.new(App.config).call(@current_account)
          group_events = Group_events.new(group_events_list)
          
          view :'group_events',
              locals: { current_user: @current_account, group_events: group_events, show_cat: "all" }
        end


        @group_events_route = '/group_events'
        # GET /group_events/
        routing.get do
          if @current_account.logged_in?
            group_events_list = GetOwnedGroupEvents.new(App.config).call(@current_account)
            group_events = Group_events.new(group_events_list)
            
            view :'group_events',
                locals: { current_user: @current_account, group_events: group_events, show_cat: "owned" }
          else
            routing.redirect '/auth/login'
          end
        end

        # POST /group_events/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "GRP: #{routing.params}"
          group_data = Form::NewGroup.call(routing.params)
          if group_data.failure?
            flash[:error] = Form.message_values(group_data)
            routing.halt
          end

          CreateNewGroup.new(App.config).call(
            current_account: @current_account,
            group_data: group_data.to_h
          )

          flash[:notice] = 'Add collaborators to your new group'
        rescue StandardError => e
          puts "FAILURE Creating Group: #{e.inspect}"
          flash[:error] = 'Could not create group'
        ensure
          routing.redirect @group_events_route
        end
      end
    end
  end
end

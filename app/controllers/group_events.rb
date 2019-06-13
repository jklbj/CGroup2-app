# frozen_string_literal: true

require 'roda'

module CGroup2
  # Web controller for CGroup2 API
  class App < Roda
    route('group_events') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @groups_route = '/group_events/all'
        @group_events_route = '/group_events'

        routing.on(String) do |grp_id|
          # GET /group_events/[group_id]
          routing.get do
            if grp_id.eql? "all"
              group_events_list = GetAllGroupEvents.new(App.config).call(@current_account)
              group_events = Group_events.new(group_events_list)
              
              view :'group_events',
                  locals: { current_user: @current_account, group_events: group_events, show_cat: "all" }
            else
              group_info = GetGroupEvent.new(App.config).call(
                @current_account, grp_id
              )
              puts "group info: #{group_info}"
              group_event = Group_event.new(group_info)

              view :group_event, locals: {
                current_account: @current_account, group_event: group_event
              }
            end
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Group not found'
            routing.redirect '/'
          end

          # POST /group_events/[group_id]/members
          routing.post('members') do
            action = routing.params['action']
            member_info = Form::MemberEmail.call(routing.params)
            if member_info.failure?
              flash[:error] = Form.validation_errors(member_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddMember,
                         message: 'Success to join the group' },
              'remove' => { service: RemoveMember,
                            message: 'Removed member from the group' },
              'leave' => { service: RemoveMember,
                            message: 'Leave the group' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              member: member_info,
              group_id: grp_id,
              action: action
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find member'
          ensure
            routing.redirect @group_events_route
          end

        end
      
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

          flash[:notice] = 'Success to create a new group'
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

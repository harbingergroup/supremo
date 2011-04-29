class TicketsController < ApplicationController
	#set_tab :ticket
	# GET /tickets
	# GET /tickets.xml
	before_filter :authorised_user_to_edit_ticket, :only => [:edit, :destroy]
	before_filter :authorised_user_to_view_ticket, :only => [:show]
	#before_filter :required_admin, :only => [:index]
	def index
		if current_user.is_admin?
		@tickets = Ticket.all
		else
			@tickets_assigned = current_user.tickets
			@tickets_created = current_user.mytickets
		end
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @tickets }
		end
	end

	# GET /tickets/1
	# GET /tickets/1.xml
	def show
		@user_id = current_user.id
		@comment = Comment.new
		#@comment.audit_comment = "#{current_user.firstname} added comment for Ticket - # #{@comment.ticket_id} "

		@ticket = Ticket.find(params[:id])
		@comments = @ticket.comments.all
		@audits = Audit.find(:all, :conditions => ["auditable_type IN(?) and auditable_id=? or association_id=? and action !=?",['Ticket','Comment'], @ticket.id, @ticket.id,'destroy'])
		@department_users = @ticket.department.users
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @ticket }
		end
	end

	# GET /tickets/new
	# GET /tickets/new.xml
	def new
		@ticket = Ticket.new
		@departments = Department.all
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @ticket }
		end
	end

	# GET /tickets/1/edit
	def edit
		@ticket = Ticket.find(params[:id])
		@departments = Department.all
	end

	# POST /tickets
	# POST /tickets.xml
	def create
		@departments = Department.all
		@ticket = current_user.mytickets.new(params[:ticket])
		@ticket.audit_comment = "#{current_user.firstname} opened new Ticket for #{@ticket.department.name}"
		respond_to do |format|
			if @ticket.save
				UserMailer.new_ticket(current_user,@ticket.department.head,@ticket).deliver
				format.html { redirect_to(@ticket, :notice => 'Ticket was successfully created.') }
				format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /tickets/1
	# PUT /tickets/1.xml
	def update
		@ticket = Ticket.find(params[:id])
		@departments = Department.all
		@ticket.audit_comment = "#{current_user.firstname} updated Ticket - # #{@ticket.id} "
		respond_to do |format|
			if @ticket.update_attributes(params[:ticket])
				format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /tickets/1
	# DELETE /tickets/1.xml
	def destroy
		@ticket = Ticket.find(params[:id])
		@ticket.destroy

		respond_to do |format|
			format.html { redirect_to(tickets_url) }
			format.xml  { head :ok }
		end
	end

	def assign
		#   raise 'here '
		@ticket = Ticket.find(params[:ticket_id])
    user = User.find(params[:user_id])
		@ticket.audit_comment = " #{current_user.full_name} assigned ticket to #{user.full_name}"
    @ticket.assign_to_engineer(params[:user_id])
		@user = @ticket.assigned
		if @ticket.save
			UserMailer.ticket_assigned(current_user,@ticket.assigned,@ticket).deliver
			UserMailer.ticket_assigned(current_user,@ticket.owner,@ticket).deliver
			respond_to do |format|
				format.html {
					flash[:notice] = 'Succesfully updated the ticket'
					redirect_to(:back) }
				format.js
			end
		else
			flash[:alert] = 'Error assigning ticket'
			respond_to do |format|
				format.html { redirect_to(:back) }
				format.js
			end
		end
	rescue=>e
		logger.debug "error in ticket assign --------"+e.inspect
		respond_to do |format|
			flash[:alert] = 'Error updating the ticket'
			format.html { redirect_to(:back) }
			format.js { render :text=>"set_alert('Error')"}
		end
		end

	def reassign
		#  raise 'here'
		@ticket = Ticket.find(params[:ticket_id])
		t_log = "#{current_user.firstname} reassigned Ticket - # #{@ticket.id} "
		c_log = "#{current_user.firstname} added comment on # #{@ticket.id} "
		add_comment(@ticket,params[:comment],t_log,c_log)
		@ticket.assign_to_user(params[:user_id])
    if @ticket.save && @comment.save
			UserMailer.ticket_reassigned(current_user,@ticket.assigned,@ticket).deliver
			respond_to do |format|
				format.html {
					@comments = @ticket.comments.all
					flash[:notice] = 'Ticket assigned'
					redirect_to(:back)
				}
				format.js {
					@comments = @ticket.comments.all
				}
			end
		else
			respond_to do |format|
				flash[:alert] = 'Error updating the ticket'
				format.html { redirect_to(:back) }
			end
		end

	end

	def resolve
		#  raise 'here'
		@ticket = Ticket.find(params[:id])
		#@ticket = Ticket.find_by_id(params[:ticket_id])
		@comment = current_user.comments.new(:description => params[:comment], :ticket_id => @ticket.id)
		t_log = "#{current_user.firstname} resolved  Ticket - # #{@ticket.id} "
    c_log = "#{current_user.firstname} added comment on # #{@ticket.id} "
		add_comment(@ticket,params[:comment],t_log,c_log)
		@ticket.resolve_ticket
    if @ticket.save && @comment.save
			UserMailer.ticket_resolved(current_user,@ticket.owner,@ticket).deliver
			respond_to do |format|
				format.html {
					@comments = @ticket.comments.all
					flash[:notice] = 'Ticket resolved'
					redirect_to(:back) }
				format.js{@comments = @ticket.comments.all}
			end
		else
			respond_to do |format|
				format.html {
					flash[:alert] = 'Error updating the ticket'
					redirect_to(:back) }
			end
		end
	end

	def close
		#  raise 'here'
		@ticket = Ticket.find(params[:id])
		t_log = "#{current_user.firstname} closed the ticket - # #{@ticket.id} "
    c_log = "#{current_user.firstname} added comment on # #{@ticket.id} "
		add_comment(@ticket,params[:comment],t_log, c_log)
    @ticket.close_ticket
		if @ticket.save && @comment.save
      if @ticket.original_assigned_to
        receiver = Uaser.find(@ticket.original_assigned_to)
			  UserMailer.ticket_closed(current_user,@ticket.owner,@ticket).deliver
        UserMailer.ticket_closed(current_user,receiver,@ticket).deliver
      end
			respond_to do |format|
				format.html {
					flash[:notice] = 'Ticket closed'
					@comments = @ticket.comments.all
					redirect_to(:back) }
				format.js{@comments = @ticket.comments.all}
			end
		else
			respond_to do |format|
				flash[:alert] = 'Error updating the ticket'
				format.html { redirect_to(:back) }
			end
		end
	end

	def reopen
		#  raise 'here'
		@ticket = Ticket.find(params[:id])
		t_log = "#{current_user.firstname} reopned the Ticket - # #{@ticket.id} "
    c_log = "#{current_user.firstname} added comment on # #{@ticket.id} "
		add_comment(@ticket,params[:comment],t_log,c_log)
    @ticket.reopen_ticket
		if @ticket.save && @comment.save
			UserMailer.ticket_reopen(current_user,@ticket.assigned,@ticket).deliver
			respond_to do |format|
				format.html {
					flash[:notice] = 'Ticket reopened'
					@comments = @ticket.comments.all
					redirect_to(:back) }
				format.js{@comments = @ticket.comments.all}
			end
		else
			respond_to do |format|
				flash[:alert] = 'Error updating the ticket'
				format.html { redirect_to(:back) }
			end
		end
	end

	def add_comment(ticket,comment,t_log,c_log)
		@comment = current_user.comments.new(:description => comment, :ticket_id => ticket.id)
		@comment.audit_comment = c_log
		ticket.audit_comment = t_log
	end

	def closed
		@closed_tickets = Ticket.find_all_by_department_id(params[:department_id], :conditions => ["status=?", 4])
	end

	def assigned
		@assigned_tickets = Ticket.find_all_by_department_id(params[:department_id], :conditions => ["status=?", 1])
	end

end

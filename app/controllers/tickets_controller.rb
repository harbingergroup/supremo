class TicketsController < ApplicationController
  #set_tab :ticket
  # GET /tickets
  # GET /tickets.xml
  def index

    @tickets = Ticket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @comment = Comment.new
    #@comment.audit_comment = "#{current_user.firstname} added comment for Ticket - # #{@comment.ticket_id} "

    @ticket = Ticket.find(params[:id])
    @comments = @ticket.comments.all
    @audits = Audit.find(:all, :conditions => ["auditable_type IN(?) and auditable_id=? or association_id=?",['Ticket','Comment'], @ticket.id, @ticket.id])
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
    #@ticket.assign_to_user(params[:user_id])
    #@user = @ticket.assigned
    @user = User.find(3)
    @ticket.audit_comment = " #{current_user.full_name} assigned ticket to #{@user.full_name}"
    if @ticket.save  
      UserMailer.ticket_assigned(@ticket.department.head,@ticker.assigned,@ticket).deliver
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

  def closed
    @closed_tickets = Ticket.find_all_by_department_id(params[:department_id], :conditions => ["status=?", 4])
  end

  def assigned
    @assigned_tickets = Ticket.find_all_by_department_id(params[:department_id], :conditions => ["status=?", 1])
  end

end

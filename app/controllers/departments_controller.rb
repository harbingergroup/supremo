class DepartmentsController < ApplicationController
  #set_tab :department
  # GET /departments
  # GET /departments.xml
  def index
    @departments = Department.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
    end
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])
    limit = 5
    @new_tickets = @department.tickets.new_tickets.recent.limit(limit)
    @assigned_tickets = @department.tickets.assigned_tickets.recent.limit(limit)
    @resolved_tickets = @department.tickets.resolved_tickets.recent.limit(limit)
    @reopened_tickets = @department.tickets.reopened_tickets.recent.limit(limit)
    @closed_tickets = @department.tickets.closed_tickets.recent.limit(limit)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new
    @users = User.where("type <> 'Admin' OR type is NULL").select(["id,firstname,lastname"])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        UserMailer.department_creation(current_user,@department.head,@department).deliver
        format.html { redirect_to(@department, :notice => 'Department was successfully created.') }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to(@department, :notice => 'Department was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to(departments_url) }
      format.xml  { head :ok }
    end
  end


  # returns users belong to that department
  def users
    @dept = Department.find(params[:id])
    @users = @dept.users
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js
    end
  end



  def closed_tickets
    @department = Department.find(params[:id])
    @tickets = @department.tickets.closed_tickets.recent
    render :ticket_view
  end
  def new_tickets
    @department = Department.find(params[:id])
    @tickets = @department.tickets.new_tickets.recent
    #@p_title  = "New Tickets"
    render :ticket_view
  end
  def assigned_tickets
    @department = Department.find(params[:id])
    @tickets = @department.tickets.assigned_tickets.recent
    render :ticket_view
  end
  def reopened_tickets
    @department = Department.find(params[:id])
    @tickets = @department.tickets.reopened_tickets.recent
    render :ticket_view
  end
  def resolved_tickets
    @department = Department.find(params[:id])
    @tickets = @department.ticekts.resolved_tickets.recent
    render :ticket_view
  end

end

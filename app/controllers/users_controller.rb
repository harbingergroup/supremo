class UsersController < ApplicationController
	# GET /users
	# GET /users.xml
	before_filter :required_admin, :only => [:users, :departments]

	include ApplicationHelper
	def index
		@users = User.all

		respond_to do |format|
			format.html # index.html.rb
			format.xml  { render :xml => @users }
		end
	end

	# GET /users/1
	# GET /users/1.xml
	def show
		@user = User.find(params[:id])
		@mydepts = @user.mydepartments
		unless @mydepts.empty?
			@ticketsta = tickets_to_assign(@mydepts)
		end
		@mytickets = @user.mytickets
		@tickets = @user.tickets
		respond_to do |format|
			format.html {
				if @user.is_admin?
					redirect_to users_admins_path
				end
			}
			format.xml  { render :xml => @user }
		end
	end

	# GET /users/new
	# GET /users/new.xml
	def new
		@user = User.new
		@image = @user.build_image
		@depts = Department.all
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @user }
		end
	end

	# GET /users/1/edit
	def edit
		@user = User.find(params[:id])
		@depts = Department.all
	end

	# POST /users
	# POST /users.xml
	def create
		@user = User.new(params[:user])
		#@user.type = params[:user]['type'] ? params[:user]['type'] : 'Employee'
		@user.type = 'Employee'
		@image = Image.new(params[:user][:image_attributes])
		@user.image = @image

		respond_to do |format|
			if @user.save
				UserMailer.registration_confirmation(@user).deliver
				format.html {
					if current_user && current_user.is_admin?
						redirect_to users_admins_path
					else
						redirect_to(@user, :notice => 'User was successfully created.')
					end
				}
				format.xml  { render :xml => @user, :status => :created, :location => @user }
			else
				@depts = Department.all
				format.html { render :action => "new" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.xml
	def update
		@user = User.find(params[:id])
		logger.debug "==================================>>>>>>>>>>>>>>>> Image : #{@user.type}"

		#params[:user][:image_attributes]
		types = ['Admin','Engineer','Employee']
		if @user.type != nil
			@image = Image.new(params[@user.type.to_s.downcase][:image_attributes])
		end

		@user.image = @image
		respond_to do |format|
			if @user.update_attributes(params[:user])
				format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.xml
	def destroy
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			format.html { redirect_to(users_url) }
			format.xml  { head :ok }
		end
	end

	def users
		users = User.find(:all)
		admins = Admin.find(:all)
		@users = users - admins
	end

	def departments
		@departments = Department.all
	end

	def show_department
		@department = Department.find(params[:id])
	end

	def assign_role
		@user = User.find(params[:id])
		@user.update_attribute('type', params[:users][:type])
		respond_to do |format|
			format.js
		end
	end

	def ticket_status
		@user = current_user
		@tickets = @user.mytickets.where("status = #{params[:status]}")
		render :template=>"tickets/_mytickets",:locals=>{:tickets=>@tickets,:title=>(Ticket::TSTATUS[params[:status].to_i]+' Tickets').capitalize,:access=>"N"}
	end

	def mydepartments
		@departments = current_user.mydepartments
	end

end

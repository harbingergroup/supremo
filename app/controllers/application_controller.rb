class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    case resource
    when :user, User
      user_url(resource)
    else
      super
    end
  end
  
  def require_admin_department_head
  	department = Department.find(params[:id])
  	if current_user.is_admin? or department.head_id == current_user.id
  		return true
  	else
  		flash[:alert] = "You are not authorised to view this page."
  		redirect_to :back
  		return false
  	end
  end
  
  def require_user
 
  	if current_user.nil?
     	flash[:alert] = "You are not authorised to view this page."
  		redirect_to login_url
  		return false  		
  	else
  		return true
  	end  		
  end
  
  def authorised_user_to_edit_ticket
  	ticket = Ticket.find(params[:id])
  	if ticket.owner_id == current_user.id
  		return true
  	else
  		#redirect_back_or_default user_url(current_user)
  		flash[:alert] = "You are not authorised to perform this action."
  		redirect_to :back
  		return false
  	end
  end
  
  def authorised_user_to_view_ticket
  	ticket = Ticket.find(params[:id])
  	if ticket.assigned_to == current_user.id or ticket.original_assigned_to == current_user.id or ticket.owner_id == current_user.id or ticket.department.head_id == current_user.id
  		return true
  	else 
  		#redirect_back_or_default user_url(current_user)
  		flash[:alert] = "You are not authorised to view this page."
  		redirect_to :back
  		return false
  	end
  end
  
  def required_admin
  	if current_user.is_admin? 
  		return true
  	else
  		flash[:alert] = "You are not authorised to view this page."
  		redirect_to :back
  		return false
  	end
  end

      def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end

class CommentsController < ApplicationController
  
  def index
    @comments = Comment.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

 
  def new
    @comment = Comment.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

 
  def edit
    @comment = Comment.find(params[:id])
  end

  
  def create
    @ticket = Ticket.find_by_id(params[:ticket_id])
    @comment = current_user.comments.new(:description => params[:comment][:description], :ticket_id => @ticket.id)
    @comment.audit_comment = "#{current_user.firstname} added comment for Ticket - # #{@comment.ticket_id} "
    if @comment.save
      flash[:notice] = "Successfully created comment."
      @comments = @ticket.comments.all
    else
      flash[:alert] = ""
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js
    end
  end


  def update
    @ticket = Ticket.find_by_id(params[:ticket_id])
    @comment = @ticket.comments.find(params[:id])
    @comment.audit_comment = "#{current_user.firstname} updated comment for Ticket - # #{@comment.ticket_id} "
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      @comments = @ticket.comments.all
    else
      flash[:alert] = ""
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js
    end
  end

  
  def destroy
    @ticket = Ticket.find_by_id(params[:ticket_id])
    @comment = @ticket.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    @comments = @ticket.comments.all
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js
    end
  end
end

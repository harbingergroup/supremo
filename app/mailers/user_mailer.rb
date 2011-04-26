class UserMailer < ActionMailer::Base
  default :from => "admin@supremo.com"
  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registered")
  end

  def new_ticket(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "New Ticket Opened")
  end

  def ticket_assigned(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "New Ticket assigned")
  end

  def department_creation(sender,receiver,department)
      @sender = sender
      @receiver = receiver
      @department = department
      mail(:from => sender.email, :to => receiver.email, :subject => "New Department")
  end
end

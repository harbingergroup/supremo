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
    mail(:from => 'abhishek.patel@harbingergroup.com', :to => 'abhishek.patel131@gmail.com', :subject => "New Ticket Opened")
  end

  def ticket_assigned(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "New Ticket assigned")
  end

  def ticket_reassigned(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "Ticket reassigned")
  end

  def ticket_resolved(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "Ticket resolved")
  end

  def ticket_closed(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "Ticket closed")
  end

  def ticket_reopen(sender,receiver,ticket)
    @sender = sender
    @receiver = receiver
    @ticket = ticket
    mail(:from => sender.email, :to => receiver.email, :subject => "Ticket reopen")
  end

  def department_creation(sender,receiver,department)
      @sender = sender
      @receiver = receiver
      @department = department
      mail(:from => sender.email, :to => receiver.email, :subject => "New Department")
  end
end

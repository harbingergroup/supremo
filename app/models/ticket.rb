class Ticket < ActiveRecord::Base
  belongs_to :assigned, :foreign_key => "assigned_to", :class_name => "User"
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"
  has_many :comments
  belongs_to :department
  validates :title, :presence => true,:on => :create
   acts_as_audited :associated_with => :owner, :foreign_key => "owner_id", :class_name => "User"
  acts_as_audited :associated_with => :assigned, :foreign_key => "assigned_to", :class_name => "User"


  scope :recent,order("created_at DESC")
  scope :new_tickets,where("status = 0")
  scope :assigned_tickets,where("status = 1")
  scope :resolved_tickets,where("status = 2")
  scope :reopened_tickets,where("status = 3")
  scope :closed_tickets,where("status = 4")

  #has_associated_audits
  TSTATUS = ['open','assigned','resolved','reopened','closed']
  def assign_to_user(user_id)
    update_attribute(:assigned_to,user_id)
  end

  def assign_to_engineer(user_id)
    update_attributes({:assigned_to=>user_id,:original_assigned_to=>user_id})
  end
  def change_status_to(s)
     update_attribute(:status,s)
  end
  def assign_to_owner
    assign_to_user(owner_id)
  end

  def is_resolved?
    status.to_i==2
  end
  def resolve_ticket
   change_status_to(2)
   assign_to_owner
  end

  def head_of_department
    department.head
  end
  def close_ticket
    update_attribute(:status,4)
  end
  def reopen_ticket
   change_status_to(3)
   assign_to_user(original_assigned_to)
  end

  def print_status
    TSTATUS[status.to_i]
  end

  def closed?
    status==4
  end

  def not_assigned?
    assigned_to.nil?
  end
end

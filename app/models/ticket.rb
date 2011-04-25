class Ticket < ActiveRecord::Base
  belongs_to :assigned, :foreign_key => "assigned_to", :class_name => "User"
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"
  has_many :comments
  belongs_to :department
  validates :title, :presence => true,:on => :create
   acts_as_audited :associated_with => :owner, :foreign_key => "owner_id", :class_name => "User"
  acts_as_audited :associated_with => :assigned, :foreign_key => "assigned_to", :class_name => "User"


  #has_associated_audits
  TSTATUS = ['open','close','resolved','reopen']
  def assign_to_user(user_id)
    update_attribute(:assigned_to,user_id)
  end

  def print_status
    TSTATUS[status.to_i]
  end

  def not_assigned?
    assigned_to.nil?
  end
end

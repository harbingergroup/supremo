class Department < ActiveRecord::Base
  belongs_to :head, :foreign_key => "head_id", :class_name => "User"
  has_many :tickets
  has_many :users,:foreign_key=>:department_id
  
  def name_with_head
    name+" ("+head_name+")"
  end

  def head_name
    head.full_name
  end
end

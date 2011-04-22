class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket
  acts_as_audited :associated_with => :ticket
end

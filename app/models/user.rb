class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :registerable,
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:firstname,:lastname,:department_id

  # user.tickets => Tickets assigned to me
  has_many :tickets,:foreign_key=>'assigned_to'
  # user.mytickets => Tickets created by me
  has_many :mytickets,:foreign_key=>'owner_id',:class_name=>"Ticket"
  belongs_to :department
  has_many :comments
  has_many :mydepartments,:class_name => 'Department',:foreign_key=>:head_id,:conditions => "activated = true"
   has_associated_audits

	# For adding image to user profile
	has_one :image
	accepts_nested_attributes_for :image
	
	
def full_name
  firstname+" "+lastname
end

def is_admin?
	if type=='Admin'
		return true
	else
		return false
	end

end

def verify_password?(password)
    encryptor_class = Devise::Encryptors.const_get(Devise.encryptor.to_s.classify)
    encryptor_digest = encryptor_class.digest(password, Devise.stretches, self.password_salt, Devise.pepper)
    encryptor_digest == self.encrypted_password
  end


end

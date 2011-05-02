class Image < ActiveRecord::Base
	belongs_to :user
	
	has_attached_file :photo, :styles => { :thumb=> "40x40#", :small  => "100x100"},
                  :url  => "/assets_path/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets_path/users/:id/:style/:basename.:extension"
					#:path => "d:/assets_path/users/:id/:style/:basename.:extension"
	#validates_attachment_presence :photo
	#validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
	
end

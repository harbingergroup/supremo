class CreateProfileImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
	t.string :photo_file_name
    t.string :photo_content_type
    t.integer :photo_file_size
    t.integer :user_id		
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end

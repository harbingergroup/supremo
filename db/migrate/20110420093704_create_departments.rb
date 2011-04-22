class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name
      t.integer :head_id
      t.boolean :activated, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end

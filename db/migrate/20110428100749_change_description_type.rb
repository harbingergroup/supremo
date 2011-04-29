class ChangeDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :comments,:description,:text
  end

  def self.down
    change_column :comments,:description,:string
  end
end

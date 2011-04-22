class ChangeTypeOfDescription < ActiveRecord::Migration
  def self.up
    change_column :tickets,:description,:text
  end

  def self.down
    change_column :tickets,:description,:string
  end
end

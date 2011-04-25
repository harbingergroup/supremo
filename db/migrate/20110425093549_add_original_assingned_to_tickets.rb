class AddOriginalAssingnedToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets,:original_assigned_to,:integer
  end

  def self.down
    remove_column :tickets,:original_assigned_to
  end
end

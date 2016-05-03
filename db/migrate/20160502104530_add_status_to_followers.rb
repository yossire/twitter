class AddStatusToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :status, :int
  end
end

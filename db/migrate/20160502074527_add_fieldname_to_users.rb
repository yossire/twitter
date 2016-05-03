class AddFieldnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :screen_name, :string
    add_column :users, :followers_count, :int
    add_column :users, :pic_url, :string
  end
end

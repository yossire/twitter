class ChangeFollowersColumnName < ActiveRecord::Migration
  def change
    rename_column :followers, :followed_uid, :followed_by_uid
  end
end

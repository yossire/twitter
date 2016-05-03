class ChangeFollowersColumnsName < ActiveRecord::Migration
  def change
    rename_column :followers, :uid, :user_id
    rename_column :followers, :followed_by_uid, :followed_by_user_id
  end
end

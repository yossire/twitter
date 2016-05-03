class Follower < ActiveRecord::Base
  #attr_accessible :followed_uid, :uid
  belongs_to :user
  def self.set_follower(user_id, followed_by_user_id)
    where({:user_id=>user_id, :followed_by_user_id=>followed_by_user_id}).first_or_initialize.tap do |user|
      user.user_id = user_id
      user.followed_by_user_id = followed_by_user_id
      #user.status = 1
      user.save!
    end
  end
end

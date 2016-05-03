class User < ActiveRecord::Base
  has_many :followers, dependent: :destroy
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_secret = auth.credentials.secret
      user.save!
      set_followers(user.id, user.oauth_token, user.oauth_secret)
    end
  end

  def twitt(tweet)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = oauth_token
      config.access_token_secret = oauth_secret
    end
    client.update(tweet)
  end

  def say_hi(screen_name, message)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = oauth_token
      config.access_token_secret = oauth_secret
    end
    client.update("@" + screen_name + " Hi @" +screen_name+ " how are you today?")
  end

  def self.set_followers(uid, oauth_token, oauth_secret)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = oauth_token
      config.access_token_secret = oauth_secret
    end

    @followers = client.followers();
    @followers.each do |follower|
       @user_id = set_follower_as_user(uid, "twitter",follower)
       if(@user_id != 0)
         Follower.set_follower(uid, @user_id)
       end
    end
  end

  def self.set_follower_as_user(uid, provider, follower)
    $ret_user_id = 0;
    where({:provider=>provider, :uid=>follower.id}).first_or_initialize.tap do |user|
      user.provider = provider
      user.uid = follower.id
      @name = follower.name.dup
      user.name = @name.force_encoding(Encoding::UTF_8)
      @screen_name = follower.screen_name.dup
      user.screen_name = @screen_name.force_encoding(Encoding::UTF_8)
      user.followers_count = follower.followers_count
      user.pic_url = follower.profile_image_url.to_s
      begin
         user.save!
         $ret_user_id = user.id
      rescue
            $ret_user_id = 0
      end
      return $ret_user_id
    end
  end

  def activeFollowers()
    @ret = Array.new
    @followers = followers.where(:status => nil).first 5
    @followers.each do |f|
      @user = User.find(f.followed_by_user_id)
      unless @user.nil?
        @ret << @user
      end
    end
    return @ret ||= []
  end

  def notActiveFollowers()
    @ret = Array.new
    @followers = followers.where(:status => 1).first 5
    @followers.each do |f|
      @user = User.find(f.followed_by_user_id)
      unless @user.nil?
        @ret << @user
      end
    end
    if(@ret == nil)
      @ret = []
    end
    return @ret
  end

  def unfollow(follower_user_id)
    follower = followers.where(:followed_by_user_id => follower_user_id).first
    follower.status = 1
    follower.save
  end

  def follow(follower_user_id)
    follower = followers.where(:followed_by_user_id => follower_user_id).first
    follower.status = nil
    follower.save
  end
  def delete(follower_user_id)
    follower = followers.where(:followed_by_user_id => follower_user_id).first
    follower.status = 2
    follower.save
  end
end

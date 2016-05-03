class HomeController < ApplicationController
  def show
    if current_user
      @activeFollowers   = current_user.activeFollowers()
      @notActiveFollowers   = current_user.notActiveFollowers()
    end
  end
  def unfollow
    if current_user
      current_user.unfollow(params[:id])
      @activeFollowers   = current_user.activeFollowers()
      @notActiveFollowers   = current_user.notActiveFollowers()
      respond_to do |format|
        format.html{redirect_to "/"}
        format.js
      end
    end
  end
  def follow
    if current_user
      current_user.follow(params[:id])
      @activeFollowers   = current_user.activeFollowers()
      @notActiveFollowers   = current_user.notActiveFollowers()
      respond_to do |format|
        format.html{redirect_to "/"}
        format.js
      end
    end
  end
  def delete
    if current_user
      current_user.delete(params[:id])
      @activeFollowers   = current_user.activeFollowers()
      @notActiveFollowers   = current_user.notActiveFollowers()
      respond_to do |format|
        format.html{redirect_to "/"}
        format.js
      end
    end
  end
  def say_hi
    if current_user
      user = User.find(params[:id])
      if(user)
        current_user.say_hi(user.screen_name,"Hi @" + user.screen_name + "how are you today?")
        # @activeFollowers   = current_user.activeFollowers()
        # @notActiveFollowers   = current_user.notActiveFollowers()
        respond_to do |format|
          format.html{redirect_to "/"}
          format.js
        end
      end
    end
  end
end

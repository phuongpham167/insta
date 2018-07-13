class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    Notification.create(event: " is following you", user_id: user.id, type_id: 3, object_id: current_user.id)
    redirect_to request.referrer
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to request.referrer
  end
end

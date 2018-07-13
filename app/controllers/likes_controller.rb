class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    post_id = Post.find(params[:post_id])
    current_user.like(post_id)
    if current_user.id != post_id.user_id
      Notification.create(event: "You have new like", user_id: post_id.user_id, type_id: 1, object_id: post_id)
    else
    end
    redirect_to request.referrer
  end

  def destroy
    post_id = Like.find(params[:id]).post
    current_user.unlike(post_id)
    redirect_to request.referrer
  end
end

class BookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    post_id = Post.find(params[:post_id])
    current_user.bookmark(post_id)
    redirect_to request.referrer
  end

  def destroy
    post_id = Bookmark.find(params[:id]).post
    current_user.unbookmark(post_id)
    redirect_to request.referrer
  end
end

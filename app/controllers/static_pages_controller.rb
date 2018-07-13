class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @users = User.paginate(page: params[:page]).order :created_at
      @album_list = current_user.album_list
    end
  end

  def help; end

  def about; end

  def contact; end
end

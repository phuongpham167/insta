class PostCommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :correct_user, only: [:destroy, :update, :edit]

  def index
    @post_comment = PostComment.all
  end

  def new
    @post_comment = PostComment.new
  end

  def create
    @post_comment = current_user.post_comments.build post_comment_params
    if @post_comment.save
      flash[:success] = "Comment success"
      if current_user.id != @post_comment.post.user_id
        Notification.create(event: "You have new comment", user_id: @post_comment.post.user_id, type_id: 2, object_id: @post_comment.post_id)
      else
      end
      redirect_to request.referrer || root_url
    else
      flash[:danger] = "Comment couldn't empty"
      render request.referrer
    end
  end

  def update
    @post_comment = PostComment.find_by id: params[:id]
    if @post_comment.update_attributes(post_comment_params)
      flash[:success] = "Update success"
      redirect_to @post_comment.post
    else
      flash[:success] = "Update failed"
      render :edit
    end
  end

  def show
    @post_comment = PostComment.find(params[:id])
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.present?
      @post_comment.destroy
      flash[:success] = "Delete comments success"
    end
    redirect_to request.referrer || root_url
  end

  private
    def post_comment_params
      params.require(:post_comment).permit :post_id, :user_id, :content
    end

    def correct_user
      @post_comment = current_user.post_comments.find_by(id: params[:id])
      redirect_to root_url if @post_comment.nil?
    end

end

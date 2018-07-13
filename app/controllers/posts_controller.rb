class PostsController < ApplicationController
  before_action :load_post, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(create destroy)
  def index
    @post = Post.search params[:find]
    return if @post
    flash[:danger] = "No post"
    redirect_to root_url
  end

  def new
    @post = Post.new
    @post_attachment = @post.post_attachments.build
  end

  def create
    @post = current_user.posts.build post_params
    if params[:post_attachments] != nil
      if @post.save
        params[:post_attachments]["avatar"].each do |a|
            @post_attachment = @post.post_attachments.create!(:avatar => a, :post_id => @post.id)
        end
        flash[:success] = "Create Post success"
        redirect_to root_url
      else
        render "static_pages/home"
      end
    else
      flash[:danger] = "Create Post Failed"
      redirect_to root_url
    end
  end

  def show
    @post_attachments = @post.post_attachments.all
  end

  def edit
    @post = Post.find_by id: params[:id]
  end

  def update
    @post = Post.find_by id: params[:id]
    if @post.update_attributes(post_params)
      flash[:success] = "Update success"
      redirect_to @post
    else
      flash[:success] = "Update failed"
      render :edit
    end
  end

  def post_like
    @post = Post.find_by id: params[:id]
    render "show_like"
  end

  def destroy;
    if @post.destroy
      flash[:success] = "Delete success"
    else
      flash[:danger] = "Delete failed"
    end
    redirect_to request.referrer || root_url
  end

  private
    def load_post
      @post = Post.find_by id: params[:id]
      return if @post
      flash[:danger] = t ".danger"
      redirect_to root_url
    end

    def post_params
      params.require(:post).permit :caption, :tag, :album_id
    end

end

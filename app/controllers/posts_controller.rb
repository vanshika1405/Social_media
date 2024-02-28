
class PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, only: [:show]


  def index
    @posts = Post.page(params[:page]).per(10)
    render json: @posts
  end

  def create
    @post = @current_user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if can_view_post?
      render json: @post
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def liked
    @liked_posts = @current_user.likes.where(likeable_type: 'Post').map(&:likeable)
    render json: @liked_posts
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    render json: { message: 'Post deleted successfully' }, status: :ok
  end

  def unlike
    @post = Post.find(params[:id])
    @like = @post.likes.find_by(user: @current_user)

    if @like
      @like.destroy
      render json: { message: 'Post unliked successfully' }, status: :ok
    else
      render json: { error: 'You have not liked this post' }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :privacy_status)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def can_view_post?
    return true if @post.privacy_status == 'public'

    case @post.privacy_status
    when 'only_me'
      @current_user == @post.user
    when 'friends_only'
      @current_user.friends.include?(@post.user)
    else
      false
    end
  end
end


class PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, only: [:show]




def index_everyone
  @user = @current_user
  @posts = if params[:page] == 'all'
             Post.where(privacy_status: 'public')
           else
             Post.limit(10).offset(params[:page].to_i * 10)
           end

  render json: { posts: @posts }
end


  def index_my_friends
    @user = @current_user
    friend_ids = @user.friends.pluck(:id)
    @posts = Post.where(privacy_status: 'my_friends').where('user_id IN (?) OR privacy_status = ?', friend_ids, 'everyone')
                  .limit(10).offset(params[:page].to_i * 10)
    render json: { posts: @posts }
  end

  def index_only_me
    @user = @current_user
    @posts = Post.where(privacy_status: 'only_me').where(user: @user)
                  .limit(10).offset(params[:page].to_i * 10)
    render json: { posts: @posts }
  end

  def create
    @post = @current_user.posts.build(post_params)
  
    
    images = params[:post][:images]
    if images.present?
      images.each do |image|
        options = { 
          folder: "user_#{@current_user.id}",
        
        }
  
        begin
          
          image.tempfile.rewind
          upload_result = Cloudinary::Uploader.upload(image.tempfile.path, options)
          @post.images.attach(io: File.open(image.tempfile.path), filename: upload_result['original_filename'])
        ensure
        
          image.tempfile.close!
        end
      end
    end
  
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end


  
  private

  def post_params
    params.require(:post).permit(:title, :content, images: [])
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

  def share_post
    @user = @current_user
    @original_post = Post.find(params[:id])

    
    if can_share_post?(@original_post)
      
      @original_post.update(shared_post_id: @original_post.id)

      render json: { message: 'Post shared successfully', post: @original_post }, status: :created
    else
      render json: { error: 'You are not allowed to share this post' }, status: :forbidden
    end
  end
  def create_reaction
    @post = Post.find(params[:id])
    @reaction = @post.reactions.build(user: @current_user, kind: params[:kind])

    if @reaction.save
      render json: @post, status: :created
    else
      render json: { error: 'Failed to create reaction', errors: @reaction.errors.full_messages }, status: :unprocessable_entity
    end
  end




  private
  
  def can_share_post?(post)
    post.privacy_status == 'public' || post.user.friends.include?(@user)
  end

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :privacy_status)
  end

   def set_post
    @original_post = Post.find_by(id: params[:id])
    render json: { error: 'Post not found' }, status: :not_found unless @original_post
  end
end


  
  


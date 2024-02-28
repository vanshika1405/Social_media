
class CommentsController < ApplicationController
    before_action :authorize_request
  
    def create
      commentable_type = params[:commentable_type]
      commentable_id = params[:commentable_id]
      
      @commentable = commentable_type.constantize.find(commentable_id)
      @comment = @commentable.comments.build(comment_params.merge(user: @current_user))
  
      if @comment.save
        render json: @comment, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
    def liked
        @liked_comments = @current_user.likes.where(likeable_type: 'Comment').map(&:likeable)
        render json: @liked_comments
      end
      
      def unlike
        @comment = Comment.find(params[:id])
        @like = @comment.likes.find_by(user: @current_user)
    
        if @like
          @like.destroy
          render json: { message: 'Comment unliked successfully' }, status: :ok
        else
          render json: { error: 'You have not liked this comment' }, status: :unprocessable_entity
        end
      end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  

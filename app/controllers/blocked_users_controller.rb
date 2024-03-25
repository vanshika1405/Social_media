
class BlockedUsersController < ApplicationController
    before_action :authorize_request
  
    def index
        @blocked_users = @current_user.blocked_users
        render json: { blocked_users: @blocked_users }
      end
  
    def block
        user_to_block = User.find(params[:user_id])
        
        blocked_user = BlockedUser.new(user: user_to_block)
        @current_user.blocked_users << blocked_user
    
        render json: { message: 'User blocked successfully' }, status: :ok
      end
  
      def unblock
        blocked_user = @current_user.blocked_users.find_by(blocked_user_id: params[:user_id])
        if blocked_user
          blocked_user.destroy
          render json: { message: 'User unblocked successfully' }, status: :ok
        else
          render json: { error: 'User not found in blocked list' }, status: :not_found
        end
      end
      
  end
  
  
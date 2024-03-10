class FriendshipsController < ApplicationController
    before_action :authorize_request
  
    def create
      friend = User.find(params[:friend_id])
      friendship = @current_user.friendships.build(friend: friend)
  
      if friendship.save
        render json: friendship, status: :created
      else
        if friendship.errors[:base].include?("Friend request can only be sent after 30 days from the last declined request.")
          render json: { errors: friendship.errors[:base] }, status: :unprocessable_entity
        else
          render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  
    def accept
      friendship = Friendship.find(params[:id])
      friendship.update(status: 'accepted')
  
      render json: friendship, status: :ok
    end
  
    def reject
      friendship = Friendship.find(params[:id])
      friendship.destroy
  
      render json: { message: 'Friend request rejected' }, status: :ok
    end
  end
  
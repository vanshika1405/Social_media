class FriendshipsController < ApplicationController
  before_action :authorize_request

  def create
    friend = User.find(params[:friend_id])
    friendship = @current_user.friendships.build(friend: friend)

    if friendship.save
      render json: friendship, status: :created
    else
      render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
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

  def block
    friendship = Friendship.find(params[:id])
    friendship.update(status: 'blocked')

    render json: { message: 'User blocked successfully' }, status: :ok
  end

  def unblock
    friendship = Friendship.find(params[:id])
    friendship.update(status: 'accepted')

    render json: { message: 'User unblocked successfully' }, status: :ok
  end

  def remove_friend
    friendship = Friendship.find(params[:id])
    friendship.destroy

    render json: { message: 'Friend removed successfully' }, status: :ok
  end
end

  
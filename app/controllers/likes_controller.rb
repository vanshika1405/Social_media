
class LikesController < ApplicationController
  before_action :authorize_request

 

  def create
    likeable_type = params[:likeable_type]
    likeable_id = params[:likeable_id]
  
    begin
      # Attempt to find the associated record
      @likeable = likeable_type.constantize.find(likeable_id)
    rescue NameError
      # Handle the case where likeable_type is not recognized
      render json: { error: "Invalid likeable type" }, status: :unprocessable_entity
      return
    rescue ActiveRecord::RecordNotFound
      # Handle the case where the associated record is not found
      render json: { error: "Record not found" }, status: :not_found
      return
    end
  
    # Proceed with building and saving the like
    @like = @likeable.likes.build(user: @current_user)
  
    if @like.save
      render json: @like, status: :created
    else
      render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def unlike
    likeable_type = params[:likeable_type]
    likeable_id = params[:likeable_id]

    @likeable = likeable_type.constantize.find(likeable_id)
    @like = @likeable.likes.find_by(user: @current_user)

    if @like&.destroy
      render json: { message: 'Unliked successfully!' }
    else
      render json: { error: 'Unable to unlike.' }, status: :unprocessable_entity
    end
  end
end

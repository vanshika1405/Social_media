class UsersController < ApplicationController
  require 'open-uri'
  before_action :authorize_request, only: [:update, :upload_profile_pic, :upload_cover_pic]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = TokenService.encode(user_id: @user.id)
      render json: { token: token, email: @user.email }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def upload_profile_pic
    result = Cloudinary::Uploader.upload(params[:file])
    url = URI.parse(result['url'])
    
    @current_user.profile_pic.attach(io: url.open, filename: File.basename(url.path))
    
    render json: { profile_pic_url: rails_blob_path(@current_user.profile_pic, only_path: true) }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  
  

  def upload_cover_pic
    result = Cloudinary::Uploader.upload(params[:file])
    url = URI.parse(result['url'])
    @current_user.cover_pic.attach(io: url.open, filename: File.basename(url.path))
    render json: { cover_pic_url: rails_blob_path(@current_user.cover_pic, only_path: true) }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
    user = User.find(params[:id])
    render json: {
      user: user,
      followers: user.followers,
      following: user.following
    }
  end

  def send_greetings
    User.all.each do |user|
      GreetingWorker.perform_async(user.id)
    end
    render json: { message: 'Greeting emails are being sent asynchronously.' }
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :phone)
  end
end

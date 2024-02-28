class UsersController < ApplicationController
    #before_action :authorize_request, except: :create
    before_action :authorize_request, only: [:update]
    
  
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

    def show
        user = User.find(params[:id])
        render json: {
          user: user,
          followers: user.followers,
          following: user.following
        }
      end
  
    private

      def user_params

         params.require(:user).permit(:email, :name, :password, :phone)
        
      end
    
  
    end
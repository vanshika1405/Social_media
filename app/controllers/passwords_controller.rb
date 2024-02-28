class PasswordsController < ApplicationController
    before_action :authorize_request, only: [:generate_otp, :reset_with_otp, :new_password]
  
    def generate_otp
        if @current_user
          otp = @current_user.generate_otp
          UserMailer.with(user: @current_user, otp: otp).otp_email.deliver_now
          render json: { message: 'OTP sent successfully' }
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end
  
    def reset_with_otp
      if @current_user&.verify_otp(params[:otp])
        render json: { message: 'OTP verified successfully. Proceed to set a new password.' }
      else
        render json: { error: 'Invalid OTP' }, status: :unprocessable_entity
      end
    end
  
    def new_password
      if @current_user
        @current_user.update(password: params[:password], otp: nil)
        UserMailer.password_reset_confirmation(@current_user).deliver_now
        render json: { message: 'Password reset successful' }
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end
  

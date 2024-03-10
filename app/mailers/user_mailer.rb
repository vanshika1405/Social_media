class UserMailer < ApplicationMailer
    include Rails.application.routes.url_helpers
  
    def account_verification(user)
      @user = user
      mail(to: @user.email, subject: 'Account Verification')
    end
  
    def otp_email
        @user = params[:user]
        @otp = params[:otp]
        mail(to: @user.email, subject: 'Your OTP for Password Reset')
      end

      def password_reset_confirmation(user)
        @user = user
        mail(to: @user.email, subject: 'Password Reset Confirmation')
      end

      def greeting_email(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome!')
      end
  end
  
  
  
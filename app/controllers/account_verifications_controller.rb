class AccountVerificationsController < ApplicationController
    before_action :authorize_request
  
    def create
      
      UserMailer.with(user: @current_user).account_verification.deliver_now
      render json: { message: 'Account verification email sent successfully' }
    end
  
    def update
      @current_user.update(verified: true)
      render json: { message: 'Account successfully verified' }
    end
  end

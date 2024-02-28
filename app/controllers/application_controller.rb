class ApplicationController < ActionController::API
  before_action :authorize_request, :check_token_expiry, :refresh_token

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = TokenService.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def check_token_expiry
    return unless token_expired?

    # You may choose to handle token expiry differently here, e.g., log out the user
    render json: { error: 'Token expired' }, status: :unauthorized
  end

  def token_expired?
    decoded_token = TokenService.decode(request.headers['Authorization'])
    decoded_token && decoded_token['exp'] && Time.now.to_i >= decoded_token['exp']
  rescue JWT::DecodeError
    false
  end
  
  def refresh_token
  
    return unless token_expired?

    # Example: Refresh the token by issuing a new one
    new_payload = { user_id: current_user.id, exp: Time.now.to_i + 3600 } # Expires in 1 hour
    new_token = TokenService.encode(new_payload)

    # Update Authorization header with the new token
    request.headers['Authorization'] = "Bearer #{new_token}"
  end
end

  
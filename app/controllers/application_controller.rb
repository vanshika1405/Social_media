class ApplicationController < ActionController::API
  before_action :authorize_request, :check_token_expiry, :refresh_token


  private

  def authorize_request
    @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
  rescue JWT::DecodeError => e
    render json: { error: e.message }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
  

  def decoded_token
    @decoded_token ||= TokenService.decode(http_auth_header)
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    end
    nil
  end
  
  def check_token_expiry
    return unless token_expired?

    
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

    
    new_payload = { user_id: current_user.id, exp: Time.now.to_i + 3600 } # Expires in 1 hour
    new_token = TokenService.encode(new_payload)

    
    request.headers['Authorization'] = "Bearer #{new_token}"
  end
end

  
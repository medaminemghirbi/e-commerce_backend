class ApplicationController < ActionController::API
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate_request!
    header = request.headers['Authorization']
    token = header&.split(' ')&.last
    raise 'No token' if token.blank?
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id])
  rescue => e
    render json: { error: 'Unauthorized', message: e.message }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def require_admin!
    authenticate_request!
    return if performed?
    unless @current_user&.admin?
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def user_json(user, token: nil)
    data = {
      id: user.id,
      email: user.email,
      role: user.role,
      first_name: user.first_name,
      last_name: user.last_name,
      phone: user.phone
    }
    data[:token] = token if token
    data
  end
end

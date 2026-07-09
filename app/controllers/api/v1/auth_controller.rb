class Api::V1::AuthController < Api::V1::BaseController
  before_action :authenticate_request!, only: [:sign_out, :me]

  def sign_in
    user = User.find_by(email: params.dig(:user, :email)&.downcase)
    if user&.valid_password?(params.dig(:user, :password))
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user_json(user), token: token }
    else
      render json: { error: 'Email ou mot de passe incorrect' }, status: :unauthorized
    end
  end

  def sign_up
    user = User.new(
      email:                 params.dig(:user, :email),
      password:              params.dig(:user, :password),
      password_confirmation: params.dig(:user, :password_confirmation),
      first_name:            params.dig(:user, :first_name),
      last_name:             params.dig(:user, :last_name),
      phone:                 params.dig(:user, :phone),
      role:                  'client'
    )
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user_json(user), token: token }, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def sign_out
    render json: { message: 'Déconnecté avec succès' }
  end

  def me
    render json: { user: user_json(current_user) }
  end
end

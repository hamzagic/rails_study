class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :sign_in, :create ]
  before_action :require_admin!, only: [ :index, :show, :destroy ]

  def index
    users = User.all
    render json: users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { "error": user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: "Data deleted successfully" }, status: :ok
  end

  def sign_in
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      response.headers["Authorization"] = "Bearer #{token}"
      render json: {
        message: "Logged in successfully.",
        token: token,
        user: { id: user.id, email: user.email }
      }, status: :ok
    else
      render json: { error: "Invalid email or password." }, status: :unauthorized
    end
  end

  def sign_out
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      payload = Warden::JWTAuth::TokenDecoder.new.decode(token)
      JwtDenylist.create!(jti: payload["jti"], exp: Time.at(payload["exp"]))
      render json: { message: "Logged out successfully." }, status: :ok
    else
      render json: { error: "Missing token." }, status: :bad_request
    end
  end

  private

  def require_admin!
    return if current_user.is_admin?

    render json: { error: "Admin access required." }, status: :forbidden
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end

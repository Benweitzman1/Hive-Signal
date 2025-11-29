module Api
  class AuthController < ApplicationController
    def register
      username = params[:username]
      password = params[:password]

      unless username.present? && password.present?
        render json: { error: "username and password are required" }, status: :unprocessable_entity
        return
      end

      user = User.new(username: username, password: password)

      if user.save
        sign_in(user)
        render json: { user: serialize_user(user) }, status: :created
      else
        error_message = user.errors.full_messages.join(", ")
        Rails.logger.error "User registration failed: #{error_message}"
        render json: { error: error_message }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Error in register: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end

    def login
      username = params[:username]
      password = params[:password]

      unless username.present? && password.present?
        render json: { error: "username and password are required" }, status: :unprocessable_entity
        return
      end

      user = User.find_for_authentication(username: username)

      if user.nil?
        render json: { error: "Invalid username or password" }, status: :unauthorized
      elsif user.valid_password?(password)
        sign_in(user)
        render json: { user: serialize_user(user) }, status: :ok
      else
        render json: { error: "Invalid username or password" }, status: :unauthorized
      end
    rescue StandardError => e
      Rails.logger.error "Error in login: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end

    def logout
      if user_signed_in?
        sign_out(current_user)
        render json: { message: "Logged out successfully" }, status: :ok
      else
        render json: { error: "Not logged in" }, status: :unauthorized
      end
    rescue StandardError => e
      Rails.logger.error "Error in logout: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end

    def current_user_info
      if user_signed_in?
        render json: { user: serialize_user(current_user) }, status: :ok
      else
        render json: { error: "Not authenticated" }, status: :unauthorized
      end
    end

    private

    def serialize_user(user)
      {
        id: user.id.to_s,
        username: user.username
      }
    end
  end
end


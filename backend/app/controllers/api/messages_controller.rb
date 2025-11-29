module Api
  class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      phone_number = params[:phone_number]
      content = params[:content]

      unless phone_number.present? && content.present?
        render json: { error: "phone_number and content are required" }, status: :unprocessable_entity
        return
      end

      interactor = SendMessage.new(
        phone_number: phone_number,
        content: content,
        user_id: current_user.id.to_s
      )

      if interactor.call
        render json: MessageSerializer.serialize(interactor.message), status: :created
      else
        render json: { error: interactor.error }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Error creating message: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end

    def index
      messages = Message.by_user(current_user.id.to_s)
      render json: MessageSerializer.serialize_collection(messages)
    rescue StandardError => e
      Rails.logger.error "Error fetching messages: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end
  end
end

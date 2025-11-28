module Api
  class MessagesController < ApplicationController
    def create
      phone_number = params[:phone_number]
      content = params[:content]

      unless phone_number.present? && content.present?
        render json: { error: "phone_number and content are required" }, status: :unprocessable_entity
        return
      end

      session_id = get_or_create_session_id

      interactor = SendMessage.new(
        phone_number: phone_number,
        content: content,
        session_id: session_id
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
      session_id = current_session_id

      unless session_id.present?
        render json: []
        return
      end

      messages = Message.by_session(session_id)
      render json: MessageSerializer.serialize_collection(messages)
    rescue StandardError => e
      Rails.logger.error "Error fetching messages: #{e.message}"
      render json: { error: "Internal server error" }, status: :internal_server_error
    end
  end
end

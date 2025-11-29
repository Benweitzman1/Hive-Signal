class SendMessage
  attr_reader :message, :error

  def initialize(phone_number:, content:, user_id:)
    @phone_number = phone_number
    @content = content
    @user_id = user_id
    @message = nil
    @error = nil
  end

  def call
    @message = Message.new(
      phone_number: @phone_number,
      content: @content,
      user_id: @user_id
    )

    unless @message.valid?
      @error = @message.errors.full_messages.join(", ")
      return false
    end

    unless @message.save
      @error = "Failed to save message"
      return false
    end

    sms_result = Twilio::SmsSender.send_sms(@phone_number, @content)

    unless sms_result[:success]
      Rails.logger.warn "Message saved but SMS sending failed: #{sms_result[:error]}"
    end

    true
  rescue StandardError => e
    Rails.logger.error "Error in SendMessage: #{e.message}"
    @error = "Internal server error"
    false
  end
end


require 'twilio-ruby'

module Twilio
  class SmsSender
    def self.send_sms(phone_number, message_content)
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      from_number = ENV['TWILIO_PHONE_NUMBER']

      unless account_sid && auth_token && from_number
        Rails.logger.error "Twilio credentials not configured"
        return { success: false, error: "Twilio not configured" }
      end

      if Rails.env.test?
        test_message_sid = "SM#{SecureRandom.hex(16)}"
        Rails.logger.info "[TEST] SMS stubbed - would be sent to #{phone_number}"
        return { success: true, message_sid: test_message_sid, test_mode: true }
      end

      # Twilio test credentials automatically prevent charges and real SMS delivery
      begin
        client = ::Twilio::REST::Client.new(account_sid, auth_token)
        message = client.messages.create(
          body: message_content,
          to: phone_number,
          from: from_number
        )

        Rails.logger.info "SMS sent via Twilio: #{message.sid}"
        { success: true, message_sid: message.sid, test_mode: false }
      rescue ::Twilio::REST::RestError => e
        Rails.logger.error "Twilio error: #{e.message}"
        { success: false, error: e.message }
      rescue StandardError => e
        Rails.logger.error "Unexpected error sending SMS: #{e.message}"
        { success: false, error: "Failed to send SMS" }
      end
    end
  end
end


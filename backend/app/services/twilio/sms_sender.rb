# Returns success/failure hash instead of raising exceptions
require 'twilio-ruby'

module Twilio
  class SmsSender
    def self.send_sms(phone_number, message_content)
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      from_number = ENV['TWILIO_PHONE_NUMBER']

      unless account_sid && auth_token && from_number
        return { success: false, error: "Twilio not configured" }
      end

      begin
        client = ::Twilio::REST::Client.new(account_sid, auth_token)
        message = client.messages.create(
          body: message_content,
          to: phone_number,
          from: from_number
        )

        Rails.logger.info "SMS sent via Twilio: #{message.sid} to #{phone_number}"
        { success: true, message_sid: message.sid }
      rescue ::Twilio::REST::RestError => e
        Rails.logger.error "Twilio error: #{e.message}"
        { success: false, error: e.message }
      rescue StandardError => e
        Rails.logger.error "Failed to send SMS: #{e.message}"
        { success: false, error: "Failed to send SMS" }
      end
    end
  end
end


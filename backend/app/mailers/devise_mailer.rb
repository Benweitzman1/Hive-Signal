# Stub mailer for Devise - not actually used since we don't have confirmable/recoverable enabled
# This satisfies Zeitwerk autoloading requirements
module Devise
  class Mailer < ActionMailer::Base
    # No-op mailer - we don't send emails in this API-only app
  end
end


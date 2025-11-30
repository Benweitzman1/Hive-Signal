require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

require "mongoid"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = false

    config.middleware.use ActionDispatch::Cookies
    
    # Configure session store with secure cookies for production
    session_options = {
      key: '_hive_signal_session',
      expire_after: 2.weeks
    }
    
    # In production, use secure cookies for HTTPS
    if Rails.env.production?
      session_options[:secure] = true
      session_options[:same_site] = :lax
    end
    
    config.middleware.use ActionDispatch::Session::CookieStore, session_options
  end
end

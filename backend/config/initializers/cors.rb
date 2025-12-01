Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    frontend_origin = ENV.fetch('FRONTEND_ORIGIN', nil)
    
    if frontend_origin && frontend_origin != '*'
      origins frontend_origin
      use_credentials = true
    elsif Rails.env.development?
      origins 'http://localhost:4200'
      use_credentials = true
    else
      origins '*'
      use_credentials = false
    end

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: use_credentials
  end
end

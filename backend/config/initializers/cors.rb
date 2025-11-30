# CORS configuration - only needed for cross-origin requests
# Since we're using same-origin deployment, CORS is not strictly necessary
# But we keep it configured for flexibility
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # For same-origin, we can use the request origin or a specific domain
    frontend_origin = ENV.fetch('FRONTEND_ORIGIN', nil)
    
    if frontend_origin && frontend_origin != '*'
      origins frontend_origin
    else
      origins '*'
    end

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: frontend_origin && frontend_origin != '*' ? true : false
  end
end

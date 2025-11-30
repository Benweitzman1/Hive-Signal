Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow same-origin (no CORS needed) or specific origin
    origins ENV.fetch('FRONTEND_ORIGIN', '*')

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

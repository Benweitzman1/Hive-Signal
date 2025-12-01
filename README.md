# Hive Signal

A full-stack web application for sending and managing SMS messages via Twilio. Users can register, authenticate, send SMS messages, and view their message history.

## Project Structure

**Frontend**: Angular 19 with Angular Material, TypeScript, Signals-based state management  
**Backend**: Rails 7.2 API with Devise (username-based auth), Mongoid (MongoDB), Twilio SMS integration  
**Database**: MongoDB (local development or MongoDB Atlas via `MONGODB_URI`)

## Local Development

### Prerequisites

-   Node.js 20.19+ or 22.12+
-   npm
-   Ruby 3.0+
-   Bundler gem
-   **MongoDB**: Either:
    -   Install MongoDB locally and run it on `localhost:27017`, OR
    -   Create a free MongoDB Atlas account and cluster
-   **Twilio**:
    -   Twilio account (free trial is enough)
    -   A Twilio phone number that can send SMS

### Environment Variables

**Backend** (create `backend/.env` file with the following variables):

**Required:**

-   `MONGODB_URI` - Only needed if using MongoDB Atlas. If using local MongoDB, leave unset or set to `mongodb://localhost:27017/hive_signal_development`
-   `TWILIO_ACCOUNT_SID` - Get from [Twilio Test Credentials](https://console.twilio.com/us1/develop/runtime/test-credentials)
-   `TWILIO_AUTH_TOKEN` - Get from Twilio Test Credentials
-   `TWILIO_PHONE_NUMBER` - Use `+15005550006` for test credentials

**Optional:**

-   `SECRET_KEY_BASE` - Auto-generated in development if not set
-   `FRONTEND_ORIGIN` - Only needed if frontend runs on different port

**Frontend**: No env vars needed (uses `src/environments/environment.ts` for development, `environment.production.ts` for production builds)

### Quick Start

1. Install dependencies and start MongoDB:

-   Install MongoDB locally (or set up MongoDB Atlas as described above)
-   Make sure MongoDB is running before starting the Rails server

```bash
# Backend
cd backend
bundle install
rails server  # Runs on http://localhost:3000

# Frontend (new terminal)
cd frontend
npm install
npm start  # Runs on http://localhost:4200
```

## Render Deployment (Same-Origin)

In production, Rails serves **both** the API and the built Angular frontend from the **same domain**.  
If the app has been idle for a while, the **first request may take a short time to respond** while the service starts up.

### Setup Steps

1. **Create a Web Service on Render**:

    - Connect your GitHub repository
    - **Build Command**:
        ```bash
        cd backend && bundle install && cd ../frontend && npm install && npm run build -- --configuration production && cd ../backend && mkdir -p public && cp -r ../frontend/dist/frontend-temp/browser/* public/
        ```
    - **Start Command**:
        ```bash
        cd backend && bundle exec rails server -p $PORT -e production
        ```
    - **Instance Type**: Choose a small instance (the app is lightweight)

2. **Set Environment Variables**:

    - `RAILS_ENV=production`
    - `MONGODB_URI` - MongoDB Atlas connection string (format: `mongodb+srv://user:pass@cluster.mongodb.net/hive_signal_production?retryWrites=true&w=majority&authSource=admin`)
    - `SECRET_KEY_BASE` - Generate with: `cd backend && rails secret`
    - `TWILIO_ACCOUNT_SID` - Your Twilio account SID
    - `TWILIO_AUTH_TOKEN` - Your Twilio auth token
    - `TWILIO_PHONE_NUMBER` - Your Twilio phone number (e.g., `+1234567890`)
    - `FRONTEND_ORIGIN` - Optional: Set to your Render URL (e.g., `https://your-app.onrender.com`) or leave unset for wildcard CORS

3. **MongoDB Atlas Setup**:
    - Create a free M0 cluster
    - Create a database user
    - Add network access: `0.0.0.0/0` (allows connections from any IP)
    - Get connection string and add database name: `hive_signal_production`
    - Add `authSource=admin` if your user authenticates against the `admin` database

## Features (Live App)

-   Username-based registration and login (no email needed)
-   Cookie-based sessions managed by Devise
-   Send SMS messages through Twilio
-   Per-user message history stored in MongoDB
-   Responsive Angular UI with Angular Material

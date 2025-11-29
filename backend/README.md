# City Hive Messaging Backend

A minimal Rails API backend for sending, saving, and listing SMS messages with MongoDB and Twilio integration.

## Features

-   **Send Messages**: POST endpoint to send SMS via Twilio
-   **Save Messages**: Messages stored in MongoDB
-   **List Messages**: GET endpoint to retrieve messages filtered by session
-   **Session Management**: Cookie-based session IDs (no authentication required)
-   **Twilio Test Mode**: Full support for Twilio Test credentials (no charges, no real SMS)

## Prerequisites

-   Ruby 3.0 or higher
-   MongoDB (running locally on port 27017)
-   Twilio Account (for test credentials)
-   Bundler gem

## Quick Start

### 1. Install Dependencies

```bash
cd backend
bundle install
```

### 2. Start MongoDB

```bash
# macOS (Homebrew)
brew services start mongodb-community

# Linux
sudo systemctl start mongod

# Windows
# Start MongoDB service from Services panel (services.msc)
```

### 3. Configure Twilio Test Credentials

Create a `.env` file in the `backend` directory:

```env
# Twilio Test Credentials (No Charges, No Real SMS)
TWILIO_ACCOUNT_SID=AC6ef9a12bfec8a43926e398706de38b9c
TWILIO_AUTH_TOKEN=f02406a6ecb673e7d3fd1862b92f170b
TWILIO_PHONE_NUMBER=+15005550006
```

**Get your test credentials from:** https://console.twilio.com/us1/develop/runtime/test-credentials

**Important Notes:**

-   The app makes real API calls to Twilio in development
-   Twilio automatically recognizes test credentials and prevents charges
-   Twilio automatically prevents real SMS delivery with test credentials
-   In test environment (`RAILS_ENV=test`), SMS is stubbed for faster unit tests

### 4. Start the Server

```bash
rails server
```

The API will be available at `http://localhost:3000`

## API Endpoints

### POST /api/messages

Send a new SMS message.

**Request:**

```json
{
    "phone_number": "+1234567890",
    "content": "Hello, this is a test message"
}
```

**Response (201 Created):**

```json
{
    "id": "507f1f77bcf86cd799439011",
    "phone_number": "+1234567890",
    "content": "Hello, this is a test message",
    "created_at": "2024-01-15T10:30:00Z",
    "session_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

### GET /api/messages

Retrieve all messages for the current session (filtered by session ID from cookie).

**Response (200 OK):**

```json
[
    {
        "id": "507f1f77bcf86cd799439011",
        "phone_number": "+1234567890",
        "content": "Hello, this is a test message",
        "created_at": "2024-01-15T10:30:00Z"
    }
]
```

## How Twilio Test Credentials Work

### Zero Charges Guarantee

When using Twilio Test credentials:

1. **Your app makes real API calls** to Twilio
2. **Twilio recognizes test credentials** automatically (from Account SID)
3. **Twilio prevents charges** (built-in protection, cannot be bypassed)
4. **Twilio prevents real SMS** (simulated responses only)
5. **No charges possible** - Twilio enforces this at the API level

### Development Setup

Use Twilio Test credentials in development:

```env
TWILIO_ACCOUNT_SID=AC6ef9a12bfec8a43926e398706de38b9c  # Test Account SID
TWILIO_AUTH_TOKEN=f02406a6ecb673e7d3fd1862b92f170b      # Test Auth Token
TWILIO_PHONE_NUMBER=+15005550006                        # Test Phone Number
```

**Benefits:**

-   ✅ Real API calls to Twilio (full integration testing)
-   ✅ Twilio prevents charges automatically
-   ✅ Twilio prevents real SMS automatically
-   ✅ Realistic error handling

**Note:** In test environment (`RAILS_ENV=test`), SMS is automatically stubbed for faster unit tests (no API calls).

### Switching to Production

When ready for production, update `.env` with production credentials:

```env
TWILIO_ACCOUNT_SID=ACb8ff415e33f987dce8fde20e8fb73e11  # Production Account SID
TWILIO_AUTH_TOKEN=your_production_auth_token            # Production Auth Token
TWILIO_PHONE_NUMBER=+1234567890                        # Your Twilio Phone Number
```

**Warning:** Production credentials will send real SMS and incur charges.

## Session Management

The API uses cookies to manage sessions:

-   **Cookie name**: `sms_session_id`
-   **Auto-generated**: UUID created on first request
-   **Security**: HttpOnly and Secure (in production)
-   **Filtering**: Messages are filtered by session ID

## Testing the API

### Using curl

**Send a message:**

```bash
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","content":"Test message"}' \
  -c cookies.txt
```

**Get messages:**

```bash
curl -X GET http://localhost:3000/api/messages \
  -b cookies.txt
```

The `-c cookies.txt` saves the session cookie, and `-b cookies.txt` sends it back.

### Using PowerShell (Windows)

**Send a message:**

```powershell
$body = @{
    phone_number='+1234567890'
    content='Test message'
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri http://localhost:3000/api/messages `
    -Method POST `
    -Body $body `
    -ContentType 'application/json' `
    -SessionVariable session

$response.Content
```

**Get messages:**

```powershell
Invoke-WebRequest -Uri http://localhost:3000/api/messages `
    -Method GET `
    -WebSession $session
```

## Project Structure

```
backend/
├── app/
│   ├── controllers/
│   │   ├── api/
│   │   │   └── messages_controller.rb    # API endpoints
│   │   ├── concerns/
│   │   │   └── session_management.rb     # Session helper methods
│   │   └── application_controller.rb
│   ├── models/
│   │   └── message.rb                    # Message model (MongoDB)
│   └── services/
│       └── twilio_service.rb             # Twilio SMS service
├── config/
│   ├── application.rb                    # Rails configuration
│   ├── routes.rb                         # API routes
│   ├── mongodb.yml                       # MongoDB database names
│   └── initializers/
│       └── cors.rb                       # CORS configuration
├── Gemfile                               # Ruby dependencies
├── .env                                  # Environment variables (create this)
└── README.md                             # This file
```

## Troubleshooting

### MongoDB Connection Issues

-   Ensure MongoDB is running: `mongosh` should connect
-   Check MongoDB service is started (Windows: `services.msc`)
-   Default connection: `localhost:27017`

### Twilio Errors

-   Verify credentials in `.env` file
-   Check you're using test credentials (Account SID starts with `AC6ef9a12...`)
-   Ensure phone number format includes country code (e.g., `+1234567890`)

### CORS Issues

-   Frontend must be on `http://localhost:4200` (configured in `config/initializers/cors.rb`)
-   Ensure cookies are enabled in browser
-   Check browser console for CORS errors

## Database

-   **Database name**: `hive_signal_development` (or `_test`, `_production`)
-   **Collection**: `messages`
-   **Connection**: `localhost:27017`

View messages in MongoDB:

```bash
mongosh
use hive_signal_development
db.messages.find().pretty()
```

## Additional Documentation

See `BACKEND_ESSENTIALS.md` for a detailed explanation of:

-   How each component works
-   What files are essential vs optional
-   How to trim the project further
-   Step-by-step code flow explanations

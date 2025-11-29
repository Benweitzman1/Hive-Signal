# Hive Signal - SMS Messenger Frontend

Modern Angular frontend for the Hive Signal SMS messaging application.

## Features

- Send SMS messages via Twilio API
- View message history (filtered by session)
- Clean, modern UI with Angular Material
- Reactive state management with Angular Signals

## Tech Stack

- **Angular 19** - Latest Angular with standalone components
- **Angular Material** - UI component library
- **TypeScript** - Strict type checking
- **Signals** - Modern reactive state management
- **RxJS** - Reactive programming for HTTP calls

## Project Structure

```
src/app/
├── core/                    # Core services and configuration
│   ├── config/
│   │   └── env.config.ts   # API configuration
│   └── interceptors/
│       └── api.interceptor.ts  # HTTP interceptor for credentials
├── shared/                  # Shared components and utilities
│   ├── material/
│   │   └── material.imports.ts  # Material module exports
│   └── components/
│       └── loading-spinner/    # Reusable components
└── features/
    └── messages/            # Messages feature
        ├── components/
        │   ├── message-form/   # Send message form
        │   └── message-list/   # Message list display
        ├── state/
        │   └── messages.state.ts  # Signals-based state
        ├── services/
        │   └── messages.api.service.ts  # HTTP API service
        ├── models/
        │   └── message.model.ts  # TypeScript interfaces
        └── messages.routes.ts   # Feature routes
```

## Getting Started

### Prerequisites

- Node.js 20.19+ or 22.12+
- npm
- Backend server running on `http://localhost:3000`

### Installation

```bash
cd frontend
npm install
```

### Development Server

```bash
npm start
```

The app will be available at `http://localhost:4200`

### Build

```bash
npm run build
```

## Architecture

### State Management

Uses **Angular Signals** for reactive state:

- `messagesState.messages` - Array of messages
- `messagesState.loading` - Loading state
- `messagesState.error` - Error state
- Actions: `setMessages()`, `addMessage()`, `setLoading()`, `setError()`

### API Integration

- **Base URL**: `http://localhost:3000/api` (configurable via environment)
- **Endpoints**:
  - `POST /messages` - Send message
  - `GET /messages` - Get messages (filtered by session)
- **Credentials**: Cookie-based session (handled automatically via interceptor)

### Component Flow

```
MessageFormComponent (UI)
  ↓ (user submits)
messagesState (updates signals)
  ↓ (calls)
MessagesApiService (HTTP)
  ↓ (response)
messagesState (updates signals)
  ↓ (reactive update)
MessageListComponent (UI updates automatically)
```

## Key Features

- **Standalone Components** - Modern Angular architecture
- **Signals** - Reactive state without RxJS subscriptions in templates
- **Type Safety** - Strict TypeScript with interfaces
- **Error Handling** - User-friendly error messages
- **Loading States** - Visual feedback during API calls
- **Session Management** - Automatic cookie handling

## Environment Configuration

Edit `src/environments/environment.ts` to change API URL:

```typescript
export const environment = {
  production: false,
  apiUrl: "http://localhost:3000/api",
};
```

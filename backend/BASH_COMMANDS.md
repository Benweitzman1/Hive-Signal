# Bash Commands Guide

## Running the Server

### Start the Rails Server

```bash
cd backend
rails server
```

Or shorter:
```bash
cd backend
rails s
```

### Stop the Server

Press **Ctrl+C** in the terminal

---

## Sending Messages via API

### Send a Message

```bash
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Your message here"}' \
  -c cookies.txt
```

### Get All Messages

```bash
curl -X GET http://localhost:3000/api/messages \
  -b cookies.txt
```

---

## Example: Send "Hello World"

```bash
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Hello World"}' \
  -c cookies.txt
```

Then get messages:
```bash
curl -X GET http://localhost:3000/api/messages -b cookies.txt
```

---

## One-Line Commands (Easier)

### Send Message (One Line)
```bash
curl -X POST http://localhost:3000/api/messages -H "Content-Type: application/json" -d '{"phone_number":"+18777804236","content":"Hello World"}' -c cookies.txt
```

### Get Messages (One Line)
```bash
curl -X GET http://localhost:3000/api/messages -b cookies.txt
```

---

## Pretty Print JSON Response

### Send and Format Response
```bash
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Hello World"}' \
  -c cookies.txt | python -m json.tool
```

Or with `jq` (if installed):
```bash
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Hello World"}' \
  -c cookies.txt | jq
```

---

## Check Server Status

```bash
curl http://localhost:3000/up
```

---

## Complete Workflow Example

```bash
# 1. Start server (in one terminal)
cd backend
rails server

# 2. Send a message (in another terminal)
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Test message"}' \
  -c cookies.txt

# 3. Get all messages
curl -X GET http://localhost:3000/api/messages -b cookies.txt

# 4. Send another message
curl -X POST http://localhost:3000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+18777804236","content":"Second message"}' \
  -c cookies.txt

# 5. Get all messages again
curl -X GET http://localhost:3000/api/messages -b cookies.txt
```

---

## Notes

- **`-c cookies.txt`**: Saves the session cookie to a file
- **`-b cookies.txt`**: Sends the saved cookie back (for session management)
- **Phone Number**: Use `+18777804236` (Twilio's virtual number) for trial accounts
- **Server**: Must be running on `http://localhost:3000`

---

## Troubleshooting

### If curl is not found:
```bash
# Install curl (if needed)
# Windows (Git Bash): Usually included
# Linux: sudo apt-get install curl
# Mac: Usually pre-installed
```

### If you get connection refused:
- Make sure the Rails server is running
- Check it's on port 3000: `curl http://localhost:3000/up`

### If cookies don't work:
- Make sure you use `-c cookies.txt` when sending
- Make sure you use `-b cookies.txt` when getting messages
- The cookie file must be in the same directory


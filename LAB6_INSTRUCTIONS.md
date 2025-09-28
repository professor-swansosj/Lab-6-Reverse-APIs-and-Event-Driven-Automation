# Lab Instructions

## Lab Title
**`Reverse APIs and Event-Driven Automati## Deliverables
Commit and push the following to your Classroom repo:

**1) Source Code (in `src/`)**
- `src/basic_webhook_server.py` - Simple FastAPI server with a single /events endpoint that logs incoming payloads
- `src/joke_webhook_server.py` - Enhanced server that responds to joke requests by calling Dad Jokes API
- `src/card_webhook_server.py` - Server that handles card draw events using Deck of Cards API
- `src/network_webhook_server.py` - Advanced server that triggers network device commands via Netmiko based on events

**2) Data Artifacts (in `data/`)**
- `data/webhook_payloads/` - Directory containing sample JSON payloads used for testing
- `data/responses/` - Directory containing API responses and network device outputs triggered by webhooks
- `data/curl_tests/` - Directory containing cURL command examples and their outputs

**3) Logs (in `logs/`)**
- `logs/basic_webhook.log` - Contains server startup, request receipt, and payload processing logs
- `logs/joke_webhook.log` - Logs showing joke API integration and response handling
- `logs/card_webhook.log` - Logs demonstrating card API integration and deck management
- `logs/network_webhook.log` - Logs showing network device interactions triggered by webhook events
- `logs/curl_tests.log` - Record of all cURL test commands and their results

**4) Configuration Files**
- `requirements.txt` - Updated with FastAPI, uvicorn, and other dependencies
- `webhook_config.json` - Configuration file containing server settings and API endpoints

> ⚠️ **Important:** Autograding validates file presence, log message formats, functional webhook endpoints, and successful API integrations. Do not rename deliverables or modify log message formats. FastAPI`**

## Version
`v1.0 / September 2025`

## Estimated Time
`120-150 Minutes`

---

## Learning Objectives
By the end of this lab, you will be able to:
- **Objective 1** – Understand the difference between traditional APIs and reverse APIs (Webhooks) and their role in event-driven automation
- **Objective 2** – Recognize how Cisco Event-Driven Network Management (EDNM) uses Webhooks for real-time network automation
- **Objective 3** – Build a FastAPI-based Webhook listener server to receive and process HTTP POST requests with JSON payloads
- **Objective 4** – Use cURL to simulate Webhook events and trigger automated actions through your reverse API
- **Objective 5** – Integrate external APIs (Dad Jokes, Deck of Cards) with your Webhook server to create event-driven workflows
- **Objective 6** – Connect Webhook events to network device interactions using Netmiko for comprehensive automation chains
- **Objective 7** – Implement security best practices for Webhook listeners including payload validation and error handling

These objectives build foundational skills for aspiring **network engineers** and **infrastructure specialists** working with modern event-driven automation platforms.

---

## Tools & Technologies
You will use:

**Development Environment:**
- Visual Studio Code (with Dev Containers)
- Git & GitHub Classroom
- Linux CLI (bash/zsh)
- Docker/Dev Containers

**Programming & Libraries:**
- Python 3.x
- FastAPI (ASGI web framework)
- Uvicorn (ASGI server)
- Requests library
- Netmiko (network device automation)
- JSON processing

**Testing & API Tools:**
- cURL (command-line HTTP client)
- Postman (optional, for testing)

**Target Systems:**
- Cisco DevNet Always-On Sandbox (Catalyst 8k/9k)
- Dad Jokes Public API
- Deck of Cards API
- Local FastAPI Webhook server

**Network Concepts:**
- HTTP POST requests
- JSON payloads
- Webhook listeners
- Event-driven automation
- Cisco EDNM (Event-Driven Network Management)

---

## Prerequisites
Before starting, make sure you:
- **Linux CLI & Git:** Basic navigation, file manipulation, cloning, committing, and pushing to repositories
- **Python Fundamentals:** Functions, classes/methods, error handling (try/except), dictionaries, lists, file I/O
- **Network Device Experience:** Using Netmiko to connect to Cisco devices, running show commands, basic IOS CLI knowledge
- **API Experience:** Making HTTP requests with cURL and Postman, using Python requests library, understanding JSON payloads
- **Previous Labs:** Completed labs on Git/GitHub, advanced Python topics, Netmiko network automation, API consumption with requests
- **Access:** GitHub Classroom repository, Dev Container environment, Cisco DevNet Always-On Sandbox credentials

---

## Deliverables
To receive credit, you must:
- Push your code changes to GitHub
- Generate a **log file** (`lab.log`) with the exact required log entries
- Ensure the autograder can find these log messages  

> ⚠️ **Important:** No log file = no points, even if your code “worked.” The grader only checks for log entries.

---

## Overview
In this lab you will:
- **Master the concept of reverse APIs (Webhooks)** and understand how they differ from traditional API calls—instead of your script calling a server, the server calls your script when events occur
- **Explore Cisco's Event-Driven Network Management (EDNM)** to see how real network devices can trigger automation workflows through Webhooks when configuration changes, interface state changes, or threshold violations occur
- **Build progressive FastAPI servers** starting with a simple event logger, then integrating external APIs like Dad Jokes and Deck of Cards, and finally connecting to network devices via Netmiko
- **Practice event-driven automation patterns** where incoming Webhook events automatically trigger actions—eliminating the need for constant polling and creating more responsive automation systems
- **Use cURL to simulate real-world scenarios** where network events, monitoring systems, or other services send structured JSON payloads to your Webhook listeners to trigger immediate responses

This lab bridges traditional API consumption with modern event-driven architectures, showing how Webhooks enable real-time automation workflows. You'll experience both sides of the equation: building the listener (reverse API server) and sending events (simulated with cURL). By the end, you'll understand how platforms like Cisco DNA Center, Meraki Dashboard, and various monitoring tools use Webhooks to create responsive, scalable automation pipelines.

💡 **Why this matters:** Event-driven automation is the foundation of modern network operations. Instead of running scripts on schedules or manually responding to alerts, event-driven systems react instantly to changes. This approach reduces mean time to resolution (MTTR), enables proactive remediation, and scales to manage thousands of devices. Mastering Webhooks positions you for roles in NetDevOps, Site Reliability Engineering (SRE), and modern network architecture where automation isn't just helpful—it's essential for business continuity.  

---

## Logging Snippet to Include
> **INSERT THIS CODE SNIPPET AT THE VERY TOP OF YOUR CODE RIGHT AFTER YOUR IMPORT STATEMENTS. LOG MESSAGES ARE REQUIRED FOR GRADING AND WILL BE ANNOTATED IN THE INSTRUCTIONS.**

```python
from datetime import datetime, timezone
import json

def now_iso():
    return datetime.now(timezone.utc).isoformat().replace("+00:00","Z")

def log(line, path):
    with open(path, "a", encoding="utf-8") as f:
        f.write(f"{line}\n")

def log_webhook_event(event_type, payload, path):
    timestamp = now_iso()
    log(f"WEBHOOK_RECEIVED event={event_type} ts={timestamp} payload_size={len(json.dumps(payload))}", path)

# usage:
# log(f"LAB6_START ts={now_iso()}", "logs/basic_webhook.log")
# log_webhook_event("joke_request", request_payload, "logs/joke_webhook.log")
```

---

## Instructions

Follow these steps in order:

### Step 1 – Clone the Repository & Setup Environment
**What you're doing:** Getting your workspace ready and understanding the reverse API concept.

```bash
git clone <repo-url>
cd <repo-name>
```

1. Open VS Code and select "Reopen in Container" when prompted
2. Wait for the dev container to build and install dependencies
3. Verify your environment by checking available packages

**Done when:**
- Container shows "READY" status
- FastAPI and uvicorn are available in your Python environment
- You can access the Cisco DevNet Always-On Sandbox documentation

LOG REQUIREMENT: `LAB6_START ts=<timestamp>`

### Step 2 – Understand Reverse APIs vs Traditional APIs
**What you're doing:** Exploring the conceptual difference between APIs you call vs APIs that call you.

1. Review the README section on Webhooks and reverse APIs
2. Examine the provided Cisco EDNM configuration example to understand how network devices can trigger Webhooks
3. Research one real-world example of a Webhook implementation (GitHub, Slack, Stripe, etc.)

**Done when:**
- You can explain the difference between polling and push notification models
- You understand how Cisco devices use EDNM to send event notifications
- You've identified the key components of a Webhook request (URL, headers, JSON payload)

LOG REQUIREMENT: `CONCEPT_REVIEW completed=reverse_apis`

### Step 3 – Build Your First FastAPI Webhook Server
**What you're doing:** Creating a simple HTTP server that can receive POST requests with JSON payloads.

Create `src/basic_webhook_server.py` that:
1. Sets up a FastAPI application with a single POST endpoint at `/events`
2. Accepts JSON payloads and logs them to both console and file
3. Returns a simple JSON acknowledgment response
4. Includes proper error handling for malformed requests

Test your server by:
- Starting it with uvicorn on port 8000
- Keeping it running in a background terminal
- Verifying it responds to basic HTTP requests

**Done when:**
- Server starts without errors and listens on the correct port
- Endpoint accepts POST requests and logs incoming data
- Basic error handling prevents crashes from bad requests

LOG REQUIREMENT: `SERVER_STARTED type=basic port=8000`

### Step 4 – Test Your Webhook with cURL
**What you're doing:** Simulating a real Webhook event by sending structured JSON data to your server.

1. Create sample JSON payloads in `data/webhook_payloads/` for different event types
2. Use cURL to send POST requests to your `/events` endpoint
3. Verify your server receives and processes the data correctly
4. Test various payload formats and sizes

Example test scenarios:
- Send a simple event notification
- Send malformed JSON to test error handling
- Send large payloads to test processing limits

**Done when:**
- cURL successfully sends data to your server
- Server logs show received payloads with correct formatting
- Error cases are handled gracefully

LOG REQUIREMENT: `CURL_TEST successful=true payload_type=<type>`

### Step 5 – Integrate Dad Jokes API via Webhook
**What you're doing:** Building your first action-triggered Webhook by connecting incoming events to external API calls.

Create `src/joke_webhook_server.py` that:
1. Extends your basic server with event-specific handling
2. Responds to `{"event": "joke_request"}` payloads by calling the Dad Jokes API
3. Returns the joke in the HTTP response
4. Logs both the incoming event and the API response

Test the integration:
- Send joke request events via cURL
- Verify the server makes successful API calls
- Confirm jokes are returned in the response

**Done when:**
- Webhook triggers successful Dad Jokes API calls
- Responses include actual joke content
- All interactions are properly logged

LOG REQUIREMENT: `JOKE_API_CALLED response_length=<length>`

### Step 6 – Add Deck of Cards API Integration
**What you're doing:** Expanding your Webhook server to handle multiple event types and API integrations.

Enhance `src/card_webhook_server.py` to:
1. Handle both joke and card draw events in the same server
2. Manage deck state by creating new decks and drawing cards
3. Support different card operations (new deck, draw card, shuffle deck)
4. Maintain proper error handling for all API interactions

Test scenarios:
- Create a new deck via Webhook
- Draw single and multiple cards
- Handle deck exhaustion gracefully

**Done when:**
- Server handles multiple event types correctly
- Card API integration works reliably
- Deck state is managed properly across requests

LOG REQUIREMENT: `CARD_API_CALLED action=<action> deck_id=<id>`

### Step 7 – Connect to Network Devices via Webhooks
**What you're doing:** Building the capstone integration that connects Webhook events to real network device interactions.

Create `src/network_webhook_server.py` that:
1. Accepts network-related event payloads (interface checks, device status, etc.)
2. Uses Netmiko to connect to Cisco DevNet sandbox devices
3. Executes show commands based on event parameters
4. Returns structured device information in the response
5. Handles device connection errors gracefully

Supported event types should include:
- Device information requests
- Interface status checks
- Configuration verification commands

**Done when:**
- Webhook events successfully trigger network device connections
- Device output is captured and returned properly
- Connection errors are handled and logged appropriately

LOG REQUIREMENT: `NETWORK_DEVICE_CALLED device=<ip> command=<command>`

### Step 8 – Implement Security and Validation
**What you're doing:** Adding production-ready security practices to your Webhook servers.

Enhance your servers with:
1. Payload validation to ensure required fields are present
2. Request size limits to prevent abuse
3. Basic authentication or token verification
4. Input sanitization for device commands
5. Rate limiting considerations

Create a `webhook_config.json` configuration file for:
- Server settings and port configuration
- API endpoints and credentials (non-sensitive)
- Validation rules and limits

**Done when:**
- Servers validate incoming requests properly
- Security measures prevent common attack vectors
- Configuration is externalized from code

LOG REQUIREMENT: `SECURITY_VALIDATION passed=<boolean> checks=<count>`

### Step 9 – Comprehensive Testing and Documentation
**What you're doing:** Creating a complete test suite and documenting your Webhook implementations.

1. Create comprehensive cURL test scripts for all event types
2. Document payload formats and expected responses
3. Test error conditions and edge cases
4. Generate sample data showing all integrations working

Save all test commands and outputs to `data/curl_tests/` with:
- Individual test files for each event type
- Combined test script that exercises all functionality
- Expected response examples

**Done when:**
- All Webhook endpoints tested thoroughly
- Documentation covers all event types and responses
- Test artifacts demonstrate full functionality

LOG REQUIREMENT: `TESTING_COMPLETE endpoints=<count> tests=<count>`

### Step 10 – Deploy and Demonstrate Full Workflow
**What you're doing:** Running your complete event-driven automation system and demonstrating real-world applicability.

1. Start your most advanced Webhook server
2. Execute a series of cURL commands that demonstrate:
   - External API integration (jokes/cards)
   - Network device interaction
   - Error handling and validation
3. Create a summary report of your implementation

Final demonstration should show:
- Event triggers automated actions
- Multiple systems integrate seamlessly
- Proper logging and error handling throughout

**Done when:**
- Complete workflow executes successfully
- All components work together properly  
- Summary documentation captures the full implementation

LOG REQUIREMENT: `LAB6_COMPLETE workflow=full integrations=<count>`

### Step 11 – Commit, Push, and Verify
**What you're doing:** Submitting your work for automated grading.

```bash
git add .
git commit -m "Lab 6 complete: FastAPI Webhook servers with API and network integrations"
git push
```

1. Verify all required files are present in your repository
2. Check that log files contain the required messages
3. Ensure your servers can start and handle requests
4. Confirm the GitHub Actions autograder runs successfully

**Done when:**
- All deliverable files are committed and pushed
- Autograder shows green status
- Required log messages are present and correctly formatted


## :wrench: Troubleshooting & Common Pitfalls

**1. FastAPI Server Won't Start**
- **Symptom:** `ModuleNotFoundError: No module named 'fastapi'` or `No module named 'uvicorn'`
- **Fix:** Ensure you're in the dev container and dependencies are installed:
```bash
pip install fastapi uvicorn
# or
pip install -r requirements.txt
```

**2. Port Already in Use Error**
- **Symptom:** `OSError: [Errno 98] Address already in use` when starting uvicorn
- **Fix:** Either kill the existing process or use a different port:
```bash
# Find and kill existing process
lsof -ti:8000 | xargs kill -9
# Or use different port
uvicorn webhook_server:app --port 8001
```

**3. cURL Connection Refused**
- **Symptom:** `curl: (7) Failed to connect to localhost port 8000: Connection refused`
- **Fix:** Ensure your FastAPI server is running and listening on the correct interface:
```bash
# Make sure server binds to all interfaces, not just localhost
uvicorn webhook_server:app --host 0.0.0.0 --port 8000
```

**4. JSON Parsing Errors**
- **Symptom:** `JSONDecodeError` or `422 Unprocessable Entity` responses
- **Fix:** Verify your JSON payload format and Content-Type header:
```bash
# Correct cURL format
curl -X POST http://localhost:8000/events \
  -H "Content-Type: application/json" \
  -d '{"event": "test", "data": "value"}'
```

**5. FastAPI Automatic Documentation Not Loading**
- **Symptom:** Cannot access `/docs` or `/redoc` endpoints
- **Fix:** Ensure FastAPI app is properly configured and server is running:
```python
from fastapi import FastAPI
app = FastAPI(title="Webhook Server", version="1.0.0")
# Then access http://localhost:8000/docs
```

**6. External API Calls Failing**
- **Symptom:** `requests.exceptions.ConnectionError` when calling Dad Jokes or Card APIs
- **Fix:** Check internet connectivity and API endpoint URLs:
```bash
# Test connectivity
curl -I https://icanhazdadjoke.com/
curl -I https://deckofcardsapi.com/api/deck/new/
```

**7. Netmiko Connection Timeouts**
- **Symptom:** `NetMikoTimeoutException` when connecting to Cisco devices
- **Fix:** Verify DevNet sandbox credentials and device availability:
```bash
# Test basic connectivity
ping <sandbox-device-ip>
# Verify SSH access
ssh <username>@<sandbox-device-ip>
```

**8. Webhook Payload Not Processed**
- **Symptom:** Server receives request but doesn't trigger expected action
- **Fix:** Add debugging to inspect the actual payload structure:
```python
@app.post("/events")
async def receive_event(request: Request):
    payload = await request.json()
    print(f"Received payload: {payload}")  # Debug line
    print(f"Event type: {payload.get('event')}")  # Debug line
```

**9. Background Process Management**
- **Symptom:** Server stops when terminal closes or becomes unresponsive
- **Fix:** Use proper process management or run in background:
```bash
# Run server in background
nohup uvicorn webhook_server:app --host 0.0.0.0 --port 8000 &
# Or use screen/tmux for persistent sessions
```

**10. File Path and Permission Issues**
- **Symptom:** `FileNotFoundError` or `PermissionError` when writing logs/data
- **Fix:** Ensure directories exist and have proper permissions:
```bash
mkdir -p data/webhook_payloads data/responses data/curl_tests logs
chmod 755 data logs
```

## :bulb: Pro Tips

**FastAPI Best Practices**
- Use FastAPI's automatic documentation: start your server and visit `http://localhost:8000/docs` for interactive API documentation
- Implement Pydantic models for request/response validation:
```python
from pydantic import BaseModel
class WebhookEvent(BaseModel):
    event: str
    data: dict
```

**Webhook Security Hardening**
- Validate webhook signatures using HMAC to ensure requests come from trusted sources
- Implement rate limiting to prevent abuse: `pip install slowapi`
- Use environment variables for sensitive configuration: `os.getenv('WEBHOOK_SECRET')`
- Always validate and sanitize incoming data before processing

**Efficient Error Handling**
- Use FastAPI's exception handlers for consistent error responses:
```python
from fastapi import HTTPException
@app.exception_handler(ValueError)
async def value_error_handler(request, exc):
    return JSONResponse(status_code=400, content={"error": str(exc)})
```

**Async Programming Benefits**
- FastAPI is built on async/await - use async functions for I/O operations:
```python
import httpx
async def call_external_api():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com")
```

**Testing Your Webhooks**
- Use FastAPI's TestClient for unit testing:
```python
from fastapi.testclient import TestClient
client = TestClient(app)
response = client.post("/events", json={"event": "test"})
```

**Production Deployment Considerations**
- Use reverse proxy (nginx) in front of uvicorn for production
- Implement proper logging with structured logs (JSON format)
- Consider using Docker containers for consistent deployment environments
- Monitor webhook endpoint health and response times

**Event-Driven Architecture Patterns**
- Implement idempotency to handle duplicate webhook deliveries safely
- Use message queues (Redis, RabbitMQ) for handling high-volume webhook traffic
- Design webhooks to be stateless - store state in databases, not memory
- Consider webhook retry mechanisms for failed deliveries

**Network Automation Integration**
- Cache device connections when possible to improve response times
- Implement connection pooling for multiple device interactions
- Use asyncio for concurrent device operations
- Store device credentials securely (environment variables, vaults)

**Advanced cURL Techniques**
- Save and reuse authentication tokens:
```bash
# Save response headers
curl -D headers.txt -X POST http://localhost:8000/events
# Use saved tokens
TOKEN=$(curl -s http://localhost:8000/auth | jq -r .token)
```

**Monitoring and Observability**
- Add health check endpoints: `@app.get("/health")`
- Implement structured logging with correlation IDs
- Track webhook processing metrics (response times, error rates)
- Use tools like Prometheus + Grafana for webhook monitoring

**Stretch Goals for Advanced Students**
- Implement webhook payload encryption/decryption
- Add database integration for webhook event storage
- Create a web dashboard to monitor webhook activity
- Build webhook replay functionality for debugging
- Implement webhook fanout (one event triggers multiple actions)
- Add support for webhook payload transformation

## Grading and Points Breakdown

> **NOTE: ZERO CREDIT CONDITIONS**
- 0 PTS FOR THE LAB IF:
    - Any webhook server exposes sensitive credentials in logs or responses
    - Required file structure changed to avoid autograder checks
    - Code is copied from external sources without understanding/modification
- -5 pts hygiene if logs show fabricated data without corresponding functionality

| Step | Requirement | Points |
|------|-------------|--------|
| 1. Environment Setup | Dev container ready, dependencies installed | 3 |
| 2. Concept Understanding | Document reverse API concepts and EDNM examples | 3 |
| 3. Basic FastAPI Server | Create working webhook listener with /events endpoint | 8 |
| 3. Basic FastAPI Server | Server properly logs incoming requests and handles errors | 4 |
| 4. cURL Testing | Successfully send JSON payloads to webhook server | 5 |
| 4. cURL Testing | Test error conditions and various payload formats | 3 |
| 5. Dad Jokes Integration | Webhook triggers external API calls successfully | 7 |
| 5. Dad Jokes Integration | Proper response handling and error management | 3 |
| 6. Deck of Cards API | Multiple event types handled in single server | 6 |
| 6. Deck of Cards API | Deck state management across requests | 4 |
| 7. Network Device Integration | Webhook events trigger Netmiko device connections | 8 |
| 7. Network Device Integration | Device output captured and returned properly | 4 |
| 8. Security Implementation | Payload validation and basic security measures | 5 |
| 8. Security Implementation | Configuration externalized and error handling robust | 3 |
| 9. Testing & Documentation | Comprehensive test suite with documented examples | 4 |
| 10. Full Workflow Demo | Complete end-to-end demonstration working | 5 |
| 11. Submission Quality | All required files present with proper log messages | 3 |
| **TOTAL** | | **75** |

## Submission Checklist
- :green_checkmark: All FastAPI servers functional and tested
- :green_checkmark: External API integrations working (Dad Jokes, Deck of Cards)
- :green_checkmark: Network device integration via Netmiko operational
- :green_checkmark: Comprehensive cURL test suite created
- :green_checkmark: All log files contain required messages
- :green_checkmark: Security measures implemented
- :green_checkmark: Files organized in correct directory structure
- :green_checkmark: Code committed and pushed to GitHub
- :green_checkmark: GitHub Actions autograder passes

# Lab 6 Reverse APIs and Event Driven Automation

## :triangular_flag_on_post: Learning Goals
- Understand what a Webhook is and how it differs from a traditional API call (server calls you vs. you calling the server)
- Recognize the role of Webhooks in automation workflows, particularly in event-driven systems where actions are triggered automatically by predefined conditions
- Relate Webhooks to networking through examples like Cisco’s Event-Driven Network Management (EDNM), where device events (interface down, config change, etc.) trigger automation tasks
- Practice making a simple webhook call with cURL, sending structured data (JSON payloads) to an endpoint
- Connect Webhook events to actions by linking a cURL POST request to a service or script that performs an API call (e.g., retrieving a joke, drawing a card, or generating a small device report)
- Understand security considerations for Webhooks, such as authentication tokens, secret keys, and verifying payloads
- Gain confidence in event-driven automation concepts, setting the stage for more advanced orchestration and streaming telemetry later

## :globe_with_meridians: Overview:
In this lab, you’ll be introduced to the concept of **reverse APIs**, more commonly known as **Webhooks**. Unlike the APIs you’ve worked with so far—where your script initiates the request—Webhooks flip the model: the server sends data to your application when a specific event occurs. This event-driven approach is foundational in modern automation, where real-time responses are more efficient than constant polling.

You’ll begin by learning what a Webhook is and how it applies to networking, using examples such as Cisco’s **Event-Driven Network Management (EDNM)**, where device events like interface changes or configuration updates can trigger automated workflows. From there, you’ll stand up your own simple **reverse API server** using FastAPI in Python. This server will act as a Webhook listener, receiving data whenever an event (or a simulated API call) occurs. Finally, you’ll use `cURL` to send a test Webhook request to your server and trigger an action that ties back to earlier labs—for example, retrieving a joke, drawing a card, or generating a mini device report. By the end of the lab, you’ll understand the fundamentals of event-driven automation and have hands-on experience building both sides of a Webhook workflow.

### What is a Webhook?
A **Webhook** is a way for one system to automatically notify another system when something happens, without waiting for the second system to ask. In traditional APIs, your script or application makes a request to a server and waits for a response—this is known as polling. With Webhooks, the flow is reversed: when an event occurs (like a configuration change, interface going down, or a user action), the server sends a request directly to a URL you provide. That URL is your Webhook listener, and it’s essentially a lightweight API endpoint waiting for incoming data.

Think of a Webhook as **“push notifications for APIs.”** Instead of constantly checking if something changed, you register your listener once, and the server pushes the data to you in real time. The payload is usually JSON, sent with an HTTP POST request. This model makes automation more efficient and responsive because it eliminates unnecessary traffic and allows your scripts to react instantly to events. In this lab, you’ll not only learn how Webhooks work but also stand up your own listener to see them in action.

### APIs vs. Webhooks: Key Differences
While both APIs and Webhooks allow systems to exchange data, they operate in opposite ways. With a traditional API, your script or application acts as the client: it sends a request (such as a GET or POST) to a server and waits for a response. This means you control when the interaction happens, but it also requires you to continually poll for updates if you want real-time information.

A Webhook, on the other hand, flips the flow. Instead of your code initiating the request, the server sends data to you when an event occurs. This makes Webhooks event-driven, allowing your applications to react immediately without constant polling. APIs are best when you need on-demand access to resources (for example, fetching a device’s current interface list), while Webhooks excel when you need to be notified about changes as they happen (such as an interface going down or a new configuration being applied). In practice, modern automation systems often use both: APIs to pull information when needed and Webhooks to trigger workflows in response to events.

### Webhooks in Networking and Event-Driven Automation
In networking, **event-driven automation** means reacting to changes the moment they happen rather than waiting for a scheduled script or manual check. Webhooks are a natural fit for this model because they allow devices or controllers to automatically send a notification when an event occurs. Instead of polling a router every few minutes to see if an interface is down, a Webhook can immediately push an alert to your automation system as soon as the interface status changes.

Cisco and other vendors have embraced this approach in their platforms. For example, Cisco’s **Event-Driven Network Management (EDNM)** framework uses events from devices—such as configuration changes, telemetry thresholds, or state transitions—to trigger workflows. Those workflows can be anything from logging an incident to running a remediation script. By tying Webhooks into your automation toolkit, you create a pipeline where network events directly drive actions, reducing response times and making operations more proactive. In this lab, you’ll simulate this process by setting up a listener that receives Webhook data and triggers actions you’ve already practiced in earlier labs.

### Cisco Event-Driven Network Management (EDNM)
Cisco’s **Event-Driven Network Management (EDNM)** is a framework that ties real-time network events to automation workflows. Instead of waiting for periodic polling or manual intervention, EDNM allows you to define rules on the device so that when a specific event occurs—such as an interface going down, a configuration change, or a threshold being exceeded—the device automatically sends a Webhook notification to an external system. That external system (your automation platform or listener) can then take immediate action, like logging an alert, updating a dashboard, or triggering a remediation script.

EDNM essentially acts as the “glue” between device-level events and higher-level automation tools. It enables a push model where devices stream structured notifications outward, eliminating the need for constant API queries. This approach makes networks more responsive, scalable, and predictable, while reducing unnecessary traffic caused by polling.

Here’s a simple **EDNM configuration example** from a Cisco IOS XE device that sends interface state-change events to a Webhook listener:

```bash

event manager applet INTERFACE_DOWN
 event syslog pattern "Interface GigabitEthernet1, changed state to administratively down"
 action 1.0 info type routername
 action 2.0 cli command "enable"
 action 3.0 cli command "event manager environment _WEBHOOK_URL http://<webhook-server>/events"
 action 4.0 cli command "event manager action send-data uri $_WEBHOOK_URL method post body {\"event\": \"InterfaceDown\", \"interface\": \"GigabitEthernet1\"}"

```

In this example:

- The applet listens for a syslog message indicating an interface state change.

- When the pattern matches, it sets a Webhook URL and sends a POST request with a JSON payload describing the event.

While your lab won’t require students to configure EDNM directly, understanding this workflow makes it clear how Webhooks apply to real-world networking—devices can call your automation system the moment something happens, turning networks into proactive participants in automation pipelines.

### Anatomy of a Webhook Request
A Webhook request is nothing more than an **HTTP POST** that delivers structured data to a URL you control. Think of it as the event’s payload wrapped inside a standard HTTP message. At a high level, every Webhook request includes:

- **Endpoint (URL)**: The destination where the event data will be sent (your listener).

- **HTTP Method**: Almost always `POST`, since Webhooks are pushing data.

- **Headers**: Metadata about the request, such as `Content-Type: application/json`, authentication tokens, or event type identifiers.

- **Body (Payload)**: The event details in a structured format—commonly JSON. This includes key-value pairs that describe what happened.

Here’s a minimal example of what a Webhook request might look like:

```http

POST /events HTTP/1.1
Host: 192.168.1.100:8000
Content-Type: application/json
Authorization: Bearer mySecretToken

{
  "event": "InterfaceDown",
  "device": "Router1",
  "interface": "GigabitEthernet1",
  "timestamp": "2025-09-07T14:22:00Z"
}

```

In this case, the **headers** specify the format and include a token for security, while the **body** contains the actual event data. Your FastAPI listener will parse this payload, and from there you can trigger any action you’ve scripted—whether that’s logging the event, pulling data from a device, or even running one of the API workflows from earlier labs.

### Building a FastAPI Webhook Server
To receive Webhook events, you need to stand up a small reverse API server—essentially an endpoint that can listen for incoming HTTP POST requests and process their payloads. For this lab, we’ll use **FastAPI**, a modern Python web framework that makes it easy to define lightweight APIs with just a few lines of code. FastAPI will let you quickly spin up a listener that exposes a URL, accepts JSON data, and runs Python logic in response.

At its core, your server will define a single POST route (such as `/events`) that takes in a JSON body. When a Webhook request arrives, FastAPI automatically parses the payload into a Python dictionary you can print, log, or pass into other functions. This design makes it easy to connect Webhook events to the scripts you’ve already written—like fetching a joke, drawing a card, or pulling device data.

Here’s a minimal FastAPI Webhook listener example:

```python

from fastapi import FastAPI, Request

app = FastAPI()

@app.post("/events")
async def receive_event(request: Request):
    payload = await request.json()
    print("Webhook received:", payload)
    return {"status": "ok"}

```

Run this server with:

```bash

uvicorn webhook_server:app --reload --port 8000

```

This command starts a local server on port 8000, ready to accept Webhook POST requests. Whenever you send data to `http://localhost:8000/events`, the payload will be captured and displayed. In the next section, you’ll practice making test Webhook calls with `cURL` to see this in action.

### Making a Webhook Call with cURL
Once your FastAPI Webhook server is running, you can simulate an event by sending it data with `cURL`. This lets you test the listener before connecting it to a real system. Since Webhooks use HTTP POST requests, you’ll include a URL, a `Content-Type` header, and a JSON payload in your command.

Here’s an example call:

```bash

curl -X POST http://localhost:8000/events \
  -H "Content-Type: application/json" \
  -d '{"event": "InterfaceDown", "device": "Router1", "interface": "GigabitEthernet1"}'

```

When this command runs, your FastAPI server will receive the request, parse the JSON, and print the payload to the terminal. You should also see the server return a simple JSON response like `{"status": "ok"}`.

This pattern is exactly how Webhooks behave in real-world automation: instead of you polling for changes, the event data is pushed to your server. By experimenting with different payloads—such as replacing the event type with `JokeRequest` or `CardDraw`—you can tie Webhook calls into the workflows you’ve already built in previous labs. This demonstrates the power of event-driven automation: events trigger actions automatically, in real time.

### Triggering an Action via a Webhook
Receiving a payload is only half the story—the real power of Webhooks comes from tying an incoming event to an automated action. In practice, this means your FastAPI listener shouldn’t just log the payload; it should call a function, run a script, or make another API request based on the event data. For example, if the payload includes `{"event": "JokeRequest"}`, your server could call the Dad Jokes API with Python’s `requests` library and return the joke. If the payload includes `{"event": "CardDraw"}`, your server might hit the Deck of Cards API and respond with a card value.

This creates a workflow chain: an external trigger → your Webhook listener → an automated action → a response. Here’s a simple FastAPI sketch that shows how this works:

```python

from fastapi import FastAPI, Request
import requests

app = FastAPI()

@app.post("/events")
async def receive_event(request: Request):
    payload = await request.json()
    if payload.get("event") == "JokeRequest":
        joke = requests.get("https://icanhazdadjoke.com/", headers={"Accept": "application/json"}).json()
        return {"joke": joke["joke"]}
    elif payload.get("event") == "CardDraw":
        card = requests.get("https://deckofcardsapi.com/api/deck/new/draw/?count=1").json()
        return {"card": card["cards"][0]["value"] + " of " + card["cards"][0]["suit"]}
    else:
        return {"status": "unrecognized event"}

```

Now, sending a cURL Webhook call with `{"event": "JokeRequest"}` or `{"event": "CardDraw"}` will trigger the corresponding action. This demonstrates the essence of event-driven automation: instead of manually starting scripts, the system reacts automatically to incoming events in real time.

### Security Considerations with Webhooks
Because Webhooks are inbound connections to your application, security is critical. Any system on the internet could potentially send data to your listener unless you put safeguards in place. At a minimum, Webhook servers should:

- **Verify the sender** – Many platforms (GitHub, Stripe, Cisco Webex, etc.) include a secret token or HMAC signature in the request headers. Your listener should validate this against a known key to ensure the request is legitimate.

- **Use HTTPS** – Webhooks often carry sensitive operational data. Running your listener over HTTPS ensures the payload is encrypted in transit.

- **Validate payloads** – Never assume incoming data is clean. Always check that the JSON includes the fields you expect and handle unexpected input gracefully.

- **Restrict exposure** – If you’re running your FastAPI listener locally, tools like ngrok can safely tunnel traffic for testing without exposing your host broadly. In production, consider firewall rules, reverse proxies, or API gateways to tightly control access.

- **Log events securely** – Store only the necessary details, avoid logging secrets, and include timestamps so you can audit events later.

By adding these protections, your Webhook server becomes more than just a demo—it models the same practices that secure real-world event-driven automation pipelines in networking and beyond.

---

## :card_file_box: File Structure:

```
Lab-6-Reverse-APIs-and-Event-Driven-Automation/
├── README.md                           # Lab theory and concepts
├── INSTRUCTIONS_TEMPLATE.md            # Step-by-step lab instructions
├── requirements.txt                    # Python dependencies
├── webhook_config.json                 # Server configuration
├── data/
│   ├── webhook_payloads/               # Sample JSON payloads for testing
│   │   ├── joke_request.json
│   │   ├── card_draw.json
│   │   └── network_device_check.json
│   ├── responses/                      # API responses and device outputs
│   └── curl_tests/                     # cURL test scripts and outputs
│       └── test_webhooks.sh
├── src/
│   ├── __init__.py
│   ├── basic_webhook_server.py         # Simple webhook listener
│   ├── joke_webhook_server.py          # Dad Jokes API integration
│   ├── card_webhook_server.py          # Deck of Cards API integration
│   └── network_webhook_server.py       # Network device integration
└── logs/
    ├── basic_webhook.log               # Basic server logs
    ├── joke_webhook.log                # Joke API integration logs
    ├── card_webhook.log                # Card API integration logs
    ├── network_webhook.log             # Network device interaction logs
    └── curl_tests.log                  # Test execution logs
```

---

## Components

### 1. **FastAPI Webhook Servers**
Progressive implementations of HTTP servers that listen for incoming POST requests (webhooks) and trigger automated actions. Students build increasingly sophisticated servers that integrate with external APIs and network devices, demonstrating event-driven automation patterns.

### 2. **External API Integrations**
Integration with public APIs (Dad Jokes, Deck of Cards) to demonstrate how webhook events can trigger calls to external services. This shows how webhooks create automation chains where one event triggers multiple downstream actions.

### 3. **Network Device Automation**
Connection of webhook events to real network device interactions using Netmiko. Students learn how network monitoring systems, configuration changes, or device alerts can trigger immediate automated responses through webhook-driven workflows.

### 4. **Event Simulation with cURL**
Comprehensive testing suite using cURL to simulate various webhook events and payloads. This demonstrates how external systems (monitoring tools, CI/CD pipelines, other services) would trigger your webhook endpoints in production environments.

## :memo: Instructions
1. **Review Concepts**: Study the reverse API theory and Cisco EDNM examples to understand event-driven automation fundamentals
2. **Build Progressive Servers**: Create FastAPI webhook listeners starting with basic event logging and progressing to external API integration
3. **Test with cURL**: Use comprehensive cURL commands to simulate webhook events and verify your implementations
4. **Integrate Network Devices**: Connect webhook events to real Cisco device interactions using Netmiko for complete automation workflows
5. **Implement Security**: Add payload validation, error handling, and security best practices to create production-ready webhook servers

## :page_facing_up: Logging
All webhook servers must implement structured logging to track:
- **Incoming Events**: Timestamp, event type, payload size, and source information
- **API Integrations**: External API calls, response status, and processing time
- **Network Operations**: Device connections, command execution, and output capture
- **Error Conditions**: Failed requests, invalid payloads, and system errors
- **Security Events**: Validation failures, rate limiting, and authentication attempts

Log entries follow the format: `EVENT_TYPE key=value key2=value2 ts=<timestamp>`

## :green_checkmark: Grading Breakdown
- **25 pts**: FastAPI webhook server implementations (basic, joke, card, network)
- **20 pts**: External API integrations working correctly with proper error handling
- **15 pts**: Network device automation via webhooks using Netmiko
- **10 pts**: Comprehensive cURL testing suite with documented examples
- **5 pts**: Security implementation with validation and configuration management
- **Total: 75 pts**
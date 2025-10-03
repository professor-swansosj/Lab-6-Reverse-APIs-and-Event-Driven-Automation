# Lab 6 — Reverse APIs & Event-Driven Automation (Webhooks)

**Course:** Software Defined Networking  
**Module:** Network Automation Fundamentals • **Lab #:** 6  
**Estimated Time:** 120–150 minutes

## Repository structure

```text
Lab-6-Reverse-APIs-and-Event-Driven-Automation
├── .devcontainer
│   └── devcontainer.json
├── .gitignore
├── .markdownlint.json
├── .markdownlintignore
├── .pettierrc.yml
├── INSTRUCTIONS.backup.md
├── INSTRUCTIONS.md
├── LICENSE
├── README.backup.md
├── README.md
├── data
│   ├── curl_tests
│   │   └── test_webhooks.sh
│   ├── inventory.example.yml
│   └── webhook_payloads
│       ├── card_draw.json
│       ├── joke_request.json
│       └── network_device_check.json
├── lab.yml
├── prettierrc.yml
├── requirements.txt
├── src
│   ├── __init__.py
│   └── main.py
└── webhook_config.json
```


## Lab Topics

### What is a Webhook?
A webhook is a user-defined HTTP callback that is triggered by specific events. When an event occurs in a service,  the webhook sends a POST request to a specified URL with a payload containing information about the event. This allows  for real-time communication between services and enables event-driven architectures.
Common use cases for webhooks include in networking, where a network device or management system can notify an external application of configuration changes, alerts, or status updates. This is in contrast to traditional request/response APIs,  where the client must poll the server for updates.
Example services in networking that utilize webhooks include Cisco's Event-Driven Network Management (EDNM) platform, which  can trigger workflows based on network events. Webhooks typically consist of: - **URL**: The endpoint where the webhook payload is sent. - **Headers**: Metadata about the request, such as content type and authentication tokens. - **Payload**: The data sent in the body of the POST request, usually in JSON format.


### API vs Webhook
Traditional APIs operate on a request/response model, where a client sends a request to a server and waits for a response.  This often involves polling the server at regular intervals to check for updates, which can lead to inefficiencies and delays.
In contrast, webhooks follow a push model, where the server proactively sends data to the client when an event occurs.  This allows for real-time updates and reduces the need for constant polling, making webhooks more efficient for event-driven scenarios.
Key differences include: - **Initiation**: APIs require the client to initiate requests; webhooks are initiated by the server. - **Timing**: APIs may involve delays due to polling intervals; webhooks provide immediate notifications. - **Resource Usage**: APIs can consume more resources due to frequent polling; webhooks are more efficient as they only send data when necessary.


### Webhooks in Networking
Webhooks are particularly useful in networking for real-time event notifications. For example, Cisco's Event-Driven Network Management (EDNM) platform utilizes webhooks to trigger workflows based on network events. This allows network administrators to respond quickly to changes in the network environment.
In a typical webhook setup for networking, the following components are involved: - **Event Source**: The network device or management system that generates events (e.g., configuration changes, alerts). - **Webhook Listener**: The endpoint that receives webhook notifications (e.g., a FastAPI application). - **Payload**: The data sent in the webhook notification, which may include details about the event and relevant context.
By leveraging webhooks, networking tools can achieve greater automation and responsiveness, enabling more efficient management of network resources.


### Cisco EDNM & Webhooks
Cisco's Event-Driven Network Management (EDNM) platform is a powerful tool that utilizes webhooks to enable event-driven automation in networking. EDNM allows network administrators to define workflows that are triggered by specific events, such as configuration changes, device status updates, or security alerts.
In an EDNM setup, webhooks play a crucial role in facilitating communication between the network management system and external applications. When an event occurs, EDNM sends a webhook notification to a predefined URL, allowing the receiving application to process the event and take appropriate actions.
Key features of Cisco EDNM with webhooks include: - **Event Triggers**: Define specific events that will trigger webhook notifications. - **Custom Payloads**: Configure the data sent in the webhook payload to include relevant information about the event. - **Integration**: Easily integrate with other systems and applications using webhooks, enabling seamless automation across different platforms.
By leveraging webhooks in Cisco EDNM, network administrators can create dynamic and responsive workflows that enhance network management and improve operational efficiency.
An example configuration snippet for setting up a webhook in Cisco EDNM might look like the example below:


```bash
router(config)# event manager applet Webhook_Example
router(config-applet)# event syslog pattern "LINK-3-UPDOWN"
router(config-applet)# action 1.0 cli command "enable"
router(config-applet)# action 1.1 cli command "configure terminal"
router(config-applet)# action 1.2 cli command "interface GigabitEthernet0/1"
router(config-applet)# action 1.3 cli command "description Link is up"
router(config-applet)# action 1.4 cli command "end"
router(config-applet)# action 1.5 http post url "http://your-webhook-url" body "Interface GigabitEthernet0/1 is up"
router(config-applet)# action 1.6 exit
router(config-applet)# exit
router(config)# exit

```

### Creating Webhook Listeners with FastAPI
FastAPI is a modern, fast (high-performance) web framework for building APIs with Python 3.7+ based on standard Python type hints. It is particularly well-suited for creating webhook listeners due to its simplicity and efficiency.
To create a webhook listener with FastAPI, you typically define an endpoint that accepts POST requests. The endpoint processes the incoming JSON payload and performs actions based on the event data.
Here’s a basic example of a FastAPI webhook listener:


```python
from fastapi import FastAPI

app = FastAPI()

@app.post("/webhook")
async def handle_webhook(payload: dict):
    # Process the incoming webhook payload
    print("Received webhook payload:", payload)
    return {"status": "success"}

```

### Security Considerations for Webhooks
When implementing webhooks, it is crucial to consider security aspects to protect against unauthorized access and ensure the integrity of the data being transmitted. Here are some best practices for securing webhooks:
1. **Validation**: Always validate incoming webhook requests to ensure they originate from a trusted source. This can be done by checking headers, IP addresses, or using shared secrets.
2. **Authentication**: Implement authentication mechanisms such as HMAC signatures or bearer tokens to verify the authenticity of the webhook requests.
3. **Rate Limiting**: Apply rate limiting to prevent abuse and mitigate denial-of-service (DoS) attacks.
4. **Payload Size Limits**: Set limits on the size of incoming payloads to avoid resource exhaustion.
5. **HTTPS**: Use HTTPS to encrypt data in transit and protect against eavesdropping and man-in-the-middle attacks.




## License
© 2025 Your Name — Classroom use.

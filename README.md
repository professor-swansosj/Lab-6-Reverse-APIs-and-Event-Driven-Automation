# Lab 6 — Reverse APIs & Event-Driven Automation (Webhooks)

**Course:** Software Defined Networking  
**Module:** Network Automation Fundamentals • **Lab #:** 6  
**Estimated Time:** 120–150 minutes

## Objectives
- Explain what a Webhook is and how it differs from traditional request/response APIs.
- Describe event-driven automation in networking (e.g., Cisco EDNM) and how webhooks trigger workflows.
- Stand up a FastAPI webhook listener that accepts JSON payloads via POST.
- Use cURL to simulate webhook events and validate request handling.
- Integrate external APIs (Dad Jokes, Deck of Cards) as event-driven actions.
- Trigger network device interactions (Netmiko) from webhook events.
- Apply basic webhook security: validation, limits, and token checks.
- Produce logs and artifacts suitable for autograding.

## Prerequisites
- Python 3.11 (via the provided dev container)
- Accounts: GitHub
- Devices/Sandboxes: Local FastAPI webhook server, Cisco DevNet Always-On Sandbox (Catalyst 8k/9k)

## Overview
Webhooks flip the usual API pattern: instead of polling, the server calls you when events happen. You’ll build a FastAPI listener, drive it with cURL, trigger external APIs, and tie events to network device actions (Netmiko). This is the backbone of event-driven network automation.


## Resources
- [FastAPI](https://fastapi.tiangolo.com/)- [Uvicorn](https://www.uvicorn.org/)- [Requests (Python)](https://requests.readthedocs.io/en/latest/)- [Netmiko](https://ktbyers.github.io/netmiko/)- [RFC 8040 — RESTCONF](https://www.rfc-editor.org/rfc/rfc8040)- [RFC 6241 — NETCONF](https://www.rfc-editor.org/rfc/rfc6241)- [Cisco DevNet Sandboxes](https://developer.cisco.com/site/sandbox/)

## FAQ
**Q:** Why did I get HTML instead of JSON from an API?  
**A:** Set `Accept: application/json` (or `application/yang-data+json` for RESTCONF).

**Q:** My webhook server won’t start.  
**A:** Install deps in the dev container: `pip install fastapi uvicorn` or use `requirements.txt`.

**Q:** Deck of Cards draw fails.  
**A:** Create a deck first, save the `deck_id`, and pass it to the draw endpoint.



## Deliverables
- Standardized README explaining goals, overview, resources, grading, and tips.
- Step-by-step INSTRUCTIONS with required log markers and artifacts.
- Grading: **75 points**

## Grading Breakdown
| Step | Requirement | Points |
|---|---|---|
| 1 | Dev container ready; dependencies installed | 3 |
| 2 | Reverse API concepts + EDNM documented | 3 |
| 3 | Basic FastAPI server with /events endpoint | 8 |
| 3 | Server logs requests and handles errors | 4 |
| 4 | cURL sends JSON successfully | 5 |
| 4 | Error cases tested and handled | 3 |
| 5 | Dad Jokes integration via webhook | 7 |
| 5 | Proper response handling and errors | 3 |
| 6 | Deck of Cards integration; multiple events | 6 |
| 6 | Deck state management | 4 |
| 7 | Netmiko device interaction via webhook | 8 |
| 7 | Device output captured and returned | 4 |
| 8 | Security and validation implemented | 5 |
| 8 | Config externalized; robust errors | 3 |
| 9 | Comprehensive tests + docs | 4 |
| 10 | End-to-end demo works | 5 |
| 11 | Submission quality; required logs present | 3 |
| **Total** |  | **75** |

## 🔧 Troubleshooting & Pro Tips
**Port in use**  
*Symptom:* Uvicorn fails on 8000  
*Fix:* Kill the process or run `--port 8001`.

**cURL refused**  
*Symptom:* Connection refused to localhost  
*Fix:* Bind to 0.0.0.0 and ensure the server is running.

**Missing logs**  
*Symptom:* Autograder can’t find markers  
*Fix:* Use the provided `log(...)` helper and correct file paths.



## Autograder Notes
- Log file: `logs/*.log`
- Required markers: `LAB6_START`, `SERVER_STARTED`, `CURL_TEST`, `WEBHOOK_RECEIVED`, `JOKE_API_CALLED`, `CARD_API_CALLED`, `NETWORK_DEVICE_CALLED`, `SECURITY_VALIDATION`, `TESTING_COMPLETE`, `LAB6_COMPLETE`

## License
© 2025 Your Name — Classroom use.
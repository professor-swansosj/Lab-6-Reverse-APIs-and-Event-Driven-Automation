# Instructions — Lab 6 — Reverse APIs & Event-Driven Automation (Webhooks)

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


> **Before you begin:** Open the dev container, confirm `python --version` prints 3.11+, and ensure outbound HTTPS works. Create `logs/`, `data/webhook_payloads/`, `data/responses/`, and `data/curl_tests/` if missing.


## Resources
- [FastAPI](https://fastapi.tiangolo.com/)- [Uvicorn](https://www.uvicorn.org/)- [Requests (Python)](https://requests.readthedocs.io/en/latest/)- [Netmiko](https://ktbyers.github.io/netmiko/)- [RFC 8040 — RESTCONF](https://www.rfc-editor.org/rfc/rfc8040)- [RFC 6241 — NETCONF](https://www.rfc-editor.org/rfc/rfc6241)- [Cisco DevNet Sandboxes](https://developer.cisco.com/site/sandbox/)
## Deliverables
- Standardized README explaining goals, overview, resources, grading, and tips.
- Step-by-step INSTRUCTIONS with required log markers and artifacts.
- Grading: **75 points**

Follow these steps in order.

> **Logging Requirement:** Write progress to `logs/*.log` as you complete each step.

## Step 1 — Clone the Repository & Setup
**Goal:** Get workspace ready; confirm environment.

**What to do:**  
Clone your Classroom repo, open in VS Code, and reopen in the dev container.
Verify Python and dependencies; create the data/logs folders if needed.


**You’re done when:**  
- Dev container shows READY
- Dependencies installed (fastapi, uvicorn, requests)
- `logs/DEVCONTAINER_STATUS.txt` updated


**Log marker to add:**  
`[LAB6_START]`

## Step 2 — Understand Reverse APIs (Webhooks)
**Goal:** Grasp polling vs push; relate to EDNM.

**What to do:**  
Read the README section on webhooks, skim EDNM examples, and note webhook anatomy:
URL, headers, JSON payload.


**You’re done when:**  
You can explain polling vs push and list webhook parts.

**Log marker to add:**  
`[CONCEPT_REVIEW]`

## Step 3 — Build Basic FastAPI Webhook Server
**Goal:** Receive JSON via POST and log it.

**What to do:**  
Implement `src/basic_webhook_server.py` with POST `/events`, parse JSON, log to file,
return `{ "status": "ok" }`, and handle bad input cleanly.
Start with `uvicorn basic_webhook_server:app --host 0.0.0.0 --port 8000`.


**You’re done when:**  
Server runs and accepts POSTs without crashing.

**Log marker to add:**  
`[SERVER_STARTED]`

## Step 4 — Test Webhook with cURL
**Goal:** Simulate events and validate handling.

**What to do:**  
Create sample payloads under `data/webhook_payloads/` and send them with cURL to `/events`.
Include one malformed JSON test and record results to `logs/curl_tests.log`.


**You’re done when:**  
Valid and invalid payloads both handled; logs updated.

**Log marker to add:**  
`[CURL_TEST]`

## Step 5 — Joke API via Webhook
**Goal:** Trigger external API based on event.

**What to do:**  
Implement `src/joke_webhook_server.py` that responds to `{"event":"joke_request"}` by
calling Dad Jokes (`Accept: application/json`), returning the joke and logging the call.


**You’re done when:**  
Jokes returned and logged.

**Log marker to add:**  
`[JOKE_API_CALLED]`

## Step 6 — Deck of Cards via Webhook
**Goal:** Support multiple event types and state.

**What to do:**  
Implement `src/card_webhook_server.py` that handles `new_deck`, `draw`, `shuffle`,
persists `deck_id`, and logs actions and outcomes.


**You’re done when:**  
Deck created/drawn/shuffled via webhook events.

**Log marker to add:**  
`[CARD_API_CALLED]`

## Step 7 — Network Device via Webhook
**Goal:** Trigger Netmiko interactions from events.

**What to do:**  
Implement `src/network_webhook_server.py` that accepts device/action params,
connects to DevNet sandbox with Netmiko, runs show commands, returns structured data,
and logs connection/command results and errors.


**You’re done when:**  
Device output returned; errors handled gracefully.

**Log marker to add:**  
`[NETWORK_DEVICE_CALLED]`

## Step 8 — Security & Validation
**Goal:** Harden the listener.

**What to do:**  
Add payload validation, size limits, optional bearer token check, and input sanitization.
Externalize non-secret config to `webhook_config.json`.


**You’re done when:**  
Bad inputs rejected; config read from file.

**Log marker to add:**  
`[SECURITY_VALIDATION]`

## Step 9 — Comprehensive Testing & Docs
**Goal:** Exercise all endpoints and document.

**What to do:**  
Write cURL scripts for every event type, capture responses to `data/responses/`,
and document formats and expected outcomes.


**You’re done when:**  
All endpoints tested; artifacts present.

**Log marker to add:**  
`[TESTING_COMPLETE]`

## Step 10 — Demo & Submit
**Goal:** Run the full workflow and submit.

**What to do:**  
Run your most capable server, execute a scripted demo of all features,
ensure logs contain the required markers, commit/push, and open a PR.


**You’re done when:**  
PR is open and Verify Docs is green.

**Log marker to add:**  
`[LAB6_COMPLETE]`


## FAQ
**Q:** Why did I get HTML instead of JSON from an API?  
**A:** Set `Accept: application/json` (or `application/yang-data+json` for RESTCONF).

**Q:** My webhook server won’t start.  
**A:** Install deps in the dev container: `pip install fastapi uvicorn` or use `requirements.txt`.

**Q:** Deck of Cards draw fails.  
**A:** Create a deck first, save the `deck_id`, and pass it to the draw endpoint.


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

## Autograder Notes
- Log file: `logs/*.log`
- Required markers: `LAB6_START`, `SERVER_STARTED`, `CURL_TEST`, `WEBHOOK_RECEIVED`, `JOKE_API_CALLED`, `CARD_API_CALLED`, `NETWORK_DEVICE_CALLED`, `SECURITY_VALIDATION`, `TESTING_COMPLETE`, `LAB6_COMPLETE`

## Submission Checklist
- [ ] All four servers present under `src/` and start without tracebacks.
- [ ] cURL scripts under `data/curl_tests/` exercise each event type.
- [ ] Artifacts saved under `data/responses/`.
- [ ] Logs contain all required markers for each phase.
- [ ] README/INSTRUCTIONS rendered from template; PR passes Verify Docs.

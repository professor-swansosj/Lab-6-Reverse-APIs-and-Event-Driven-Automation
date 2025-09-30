# Instructions — Lab 6 — Reverse APIs & Event-Driven Automation (Webhooks)

> **Before you begin:** Open the dev container, confirm `python --version` prints 3.11+, and ensure outbound HTTPS works. Create `logs/`, `data/webhook_payloads/`, `data/responses/`, and `data/curl_tests/` if missing.


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


## Submission Checklist
- [ ] All four servers present under `src/` and start without tracebacks.
- [ ] cURL scripts under `data/curl_tests/` exercise each event type.
- [ ] Artifacts saved under `data/responses/`.
- [ ] Logs contain all required markers for each phase.
- [ ] README/INSTRUCTIONS rendered from template; PR passes Verify Docs.

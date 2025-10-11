# Instructions — Lab 6 — Reverse APIs & Event-Driven Automation (Webhooks)

## Objectives
- Explain webhooks (reverse APIs) and event-driven automation.
- Build a FastAPI webhook service with ≥5 paths (joke, card draw, Netmiko, RESTCONF, NETCONF).
- Secure endpoints with a shared token; implement validation and logging.
- Persist artifacts (raw responses and summaries) for grading.
- Configure a Cisco EEM applet to call the webhook on interface-down and back up device config.

## Prerequisites
- Python 3.11 (via the provided dev container)
- Accounts: GitHub, Cisco DevNet
- Devices/Sandboxes: Local FastAPI server, Cisco DevNet Always-On Catalyst 8k/9k (SSH/RESTCONF/NETCONF)
- Technical: - Intermediate Python (functions, modules, exceptions, logging).
- FastAPI + Uvicorn basics.
- requests, netmiko, ncclient, and xmltodict usage.
- cURL or Postman to send webhook events.
- Access to Cisco DevNet Always-On sandbox and credentials.

## Overview
Build a FastAPI webhook service with five POST endpoints: Dad Jokes, Deck of Cards, Netmiko command, RESTCONF request, and NETCONF RPC. Protect endpoints with a shared token, save artifacts under data/, and log deterministic markers for autograding. Then configure a Cisco EEM applet on the sandbox device that triggers a webhook POST when an interface goes down. Back up the device configuration and include it in the repository.


> **Before you begin:** Open the dev container. Verify imports: `python -c "import fastapi, uvicorn, requests, netmiko, ncclient, xmltodict; print('OK')"` Ensure you can write to `data/` and `logs/`. Confirm sandbox reachability (TCP 22/443/830).


## Resources
- [FastAPI](https://fastapi.tiangolo.com/)- [Uvicorn](https://www.uvicorn.org/)- [Requests (Python)](https://requests.readthedocs.io/en/latest/)- [Netmiko](https://ktbyers.github.io/netmiko/)- [ncclient](https://ncclient.readthedocs.io/)- [xmltodict](https://github.com/martinblech/xmltodict)- [Cisco DevNet Sandboxes](https://developer.cisco.com/site/sandbox/)- [Cisco EEM (Embedded Event Manager) Overview](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/eem/command/eem-cr-book/eem-cr-a1.html)
## Deliverables
- `src/app.py` (FastAPI app) with ≥5 paths: `/joke`, `/card/draw`, `/device/command`, `/restconf/system`, `/netconf/system` (POST + token).
- `data/` artifacts: `joke.json/txt`, `card.json/txt`, `device_cmd.txt`, `restconf_*.json`, `netconf_*.xml/txt`, and `summary.txt`.
- `logs/lab6.log` with required markers from startup, security checks, and each action.
- `data/device_running_config.txt` (sandbox running-config backup).
- `data/eem_config.txt` containing the EEM applet configuration you applied.
- Pull request open to `main` with all artifacts committed.
- Grading: **75 points**

Follow these steps in order.

> **Logging Requirement:** Write progress to `logs/lab6.log` as you complete each step.

## Step 1 — Clone the Repository
**Goal:** Get your starter locally.

**What to do:**  
Clone your Classroom repo and `cd` into it. Create `src/`, `data/`, and `logs/` if missing.
Initialize the lab log: `echo 'LAB6_START' >> logs/lab6.log`


**You're done when:**  
- Folders exist and initial log marker written.


**Log marker to add:**  
`[LAB6_START]`

## Step 2 — Environment & Packages
**Goal:** Standardize the toolchain.

**What to do:**  
Reopen in dev container. Verify FastAPI/Uvicorn/Requests/Netmiko/ncclient/xmltodict imports.
Append `[STEP 2] Dev Container Started` and `PKG_OK:*` markers to `logs/lab6.log`.


**You're done when:**  
- Python 3.11+ confirmed, imports OK.
- Log contains `[STEP 2] Dev Container Started` and `PKG_OK: fastapi`, `PKG_OK: requests`, `PKG_OK: netmiko`, `PKG_OK: ncclient`.


**Log marker to add:**  
`[[STEP 2] Dev Container Started, PKG_OK: fastapi, PKG_OK: requests, PKG_OK: netmiko, PKG_OK: ncclient]`

## Step 3 — FastAPI App & Security
**Goal:** Expose webhook endpoints with auth and logging.

**What to do:**  
Implement `src/app.py` with:
  - FastAPI app and a startup log: `SERVER_STARTED`.
  - Shared token check (e.g., `X-Webhook-Token`) for all POST endpoints.
  - Centralized `log(marker, **fields)` helper writing to `logs/lab6.log`.
  - Pydantic models for request payloads (where applicable).
Start server: `uvicorn src.app:app --host 0.0.0.0 --port 8000`


**You're done when:**  
- Server runs and logs `SERVER_STARTED`.
- Invalid/missing token returns 401 and logs `SECURITY_VALIDATION=FAIL`.


**Log marker to add:**  
`[SERVER_STARTED, SECURITY_VALIDATION]`

## Step 4 — Endpoint 1 — /joke (Dad Jokes API)
**Goal:** Return a dad joke via webhook-triggered GET.

**What to do:**  
Validate token; GET `https://icanhazdadjoke.com/` with `Accept: application/json`.
Save JSON to `data/joke.json`, text to `data/joke.txt`, return JSON; log markers.


**You're done when:**  
- `data/joke.json` and `data/joke.txt` exist and handler returns JSON.


**Log marker to add:**  
`[WEBHOOK_RECEIVED=/joke, JOKE_API_CALLED, RAW_SAVED=joke.json]`

## Step 5 — Endpoint 2 — /card/draw (Deck of Cards)
**Goal:** Create deck and draw a card.

**What to do:**  
Create deck then draw 1 card; save `data/card.json` and `data/card.txt`, return summary; log markers.


**You're done when:**  
- `data/card.json` and `data/card.txt` exist; response includes card fields.


**Log marker to add:**  
`[WEBHOOK_RECEIVED=/card/draw, CARD_API_CALLED, RAW_SAVED=card.json]`

## Step 6 — Endpoint 3 — /device/command (Netmiko)
**Goal:** Run a show command on sandbox device.

**What to do:**  
Connect with Netmiko (`cisco_ios`), run a read-only command (e.g., `show version`).
Save output to `data/device_cmd.txt`; return short JSON; log markers.


**You're done when:**  
- Output saved to `data/device_cmd.txt`.


**Log marker to add:**  
`[WEBHOOK_RECEIVED=/device/command, NETWORK_DEVICE_CALLED, CONNECT_OK: NETMIKO]`

## Step 7 — Endpoint 4 — /restconf/system (RESTCONF)
**Goal:** Query system/platform via RESTCONF.

**What to do:**  
Use `Accept: application/yang-data+json`. Save raw `data/restconf_system.json`, return JSON summary; log markers.


**You're done when:**  
- Raw JSON saved; summary returned.


**Log marker to add:**  
`[WEBHOOK_RECEIVED=/restconf/system, RESTCONF_CALLED, RAW_SAVED=restconf_system.json]`

## Step 8 — Endpoint 5 — /netconf/system (NETCONF)
**Goal:** Query system/platform via NETCONF RPC.

**What to do:**  
Connect with `ncclient.manager.connect(..., port=830)`. Save raw XML `data/netconf_system.xml`,
parse with `xmltodict`, return JSON summary; log markers.


**You're done when:**  
- Raw XML saved; summary JSON returned.


**Log marker to add:**  
`[WEBHOOK_RECEIVED=/netconf/system, NETCONF_CALLED, RAW_SAVED=netconf_system.xml]`

## Step 9 — Cisco EEM Applet — Webhook on Interface-Down
**Goal:** Configure an EEM applet to POST to your webhook when an interface goes down.

**What to do:**  
On the sandbox device, create an EEM applet that triggers on link-down syslog (e.g., LINK-3-UPDOWN).
The action should POST to your FastAPI webhook (token included). Save the exact applet configuration
you applied to `data/eem_config.txt`. Also back up the running configuration to `data/device_running_config.txt`
(e.g., via Netmiko `show running-config` or RESTCONF). Log markers when saved.
Note: If Guestshell/cURL or embedded HTTP client is unavailable, include an alternate IOS-XE-supported
method or a documented fallback in `data/eem_config.txt`.


**You're done when:**  
- `data/eem_config.txt` contains the applet configuration you applied.
- `data/device_running_config.txt` exists with the device running-config.
- Log includes `EEM_CONFIG_SAVED` and `CONFIG_BACKUP_SAVED`.


**Log marker to add:**  
`[EEM_CONFIG_SAVED, CONFIG_BACKUP_SAVED]`

## Step 10 — Summary File & Test Run
**Goal:** Produce a human-readable roll-up and validate endpoints with cURL.

**What to do:**  
Write `data/summary.txt` with one section per endpoint (joke, card, device, restconf, netconf),
plus a short note that the EEM applet is configured (reference `data/eem_config.txt`).
Exercise each endpoint using cURL (include token) and capture HTTP 200s. Log `TESTING_COMPLETE`.
(Optional) If policy permits, flap a lab interface to test the applet and note the time observed.


**You're done when:**  
- `data/summary.txt` exists and includes all sections.
- Log shows `TESTING_COMPLETE`.


**Log marker to add:**  
`[TESTING_COMPLETE]`

## Step 11 — Finalize & Submit
**Goal:** Close out logs and open PR.

**What to do:**  
Stop the server, append `LAB6_END` to `logs/lab6.log`.
Commit and push all changes. Open a pull request targeting `main`.


**You're done when:**  
- PR is open; artifacts present; markers complete.


**Log marker to add:**  
`[LAB6_END]`


## FAQ
**Q:** 401 Unauthorized on endpoints.  
**A:** Include the shared token header (e.g., `-H 'X-Webhook-Token: <token>'`).

**Q:** RESTCONF returned HTML, not JSON.  
**A:** Use `Accept: application/yang-data+json` and verify the RESTCONF path.

**Q:** NETCONF connection refused.  
**A:** Use port 830 and `hostkey_verify=False`; confirm sandbox credentials and reachability.

**Q:** Netmiko errors on connect.  
**A:** Check host/IP/port 22, credentials, and device_type=`cisco_ios`.

**Q:** EEM: Device lacks a direct curl/HTTP action.  
**A:** Use Guestshell to run curl, or document an IOS-XE-supported alternative in `eem_config.txt`.


## 🔧 Troubleshooting & Pro Tips
**Deterministic logging**  
*Symptom:* Autograder can’t find markers.  
*Fix:* Log exact tokens; centralize logging in one helper.

**Security first**  
*Symptom:* Endpoints accessible without auth.  
*Fix:* Validate token early; return 401 before doing any work.

**Artifacts**  
*Symptom:* Missing files under data/.  
*Fix:* Create data/ upfront; use the specified filenames.


## Grading Breakdown
| Step | Requirement | Points |
|---|---|---|
| Env | Dev container started; packages verified (`PKG_OK:*`) | 5 |
| Server | FastAPI server runs; security validation implemented (`SERVER_STARTED`, `SECURITY_VALIDATION`) | 7 |
| Joke | Joke endpoint returns JSON; artifacts saved (`JOKE_API_CALLED`, `RAW_SAVED=joke.json`) | 7 |
| Cards | Deck create + draw; artifacts saved (`CARD_API_CALLED`, `RAW_SAVED=card.json`) | 7 |
| Netmiko | Device command executed; output saved (`NETWORK_DEVICE_CALLED`, `CONNECT_OK: NETMIKO`) | 9 |
| RESTCONF | RESTCONF call succeeds; JSON parsed; saved (`RESTCONF_CALLED`) | 9 |
| NETCONF | NETCONF RPC succeeds; XML parsed; saved (`NETCONF_CALLED`) | 9 |
| EEM + Backup | Applet config saved and running-config backed up (`EEM_CONFIG_SAVED`, `CONFIG_BACKUP_SAVED`) | 10 |
| Testing | All endpoints validated; summary present (`TESTING_COMPLETE`) | 5 |
| Submission | PR open; `LAB6_START`/`LAB6_END` present; log hygiene | 7 |
| **Total** |  | **75** |

## Autograder Notes
- Log file: `logs/lab6.log`
- Required markers: `LAB6_START`, `[STEP 2] Dev Container Started`, `PKG_OK: fastapi`, `PKG_OK: requests`, `PKG_OK: netmiko`, `PKG_OK: ncclient`, `SERVER_STARTED`, `SECURITY_VALIDATION`, `WEBHOOK_RECEIVED=/joke`, `JOKE_API_CALLED`, `RAW_SAVED=joke.json`, `WEBHOOK_RECEIVED=/card/draw`, `CARD_API_CALLED`, `RAW_SAVED=card.json`, `WEBHOOK_RECEIVED=/device/command`, `NETWORK_DEVICE_CALLED`, `CONNECT_OK: NETMIKO`, `WEBHOOK_RECEIVED=/restconf/system`, `RESTCONF_CALLED`, `RAW_SAVED=restconf_system.json`, `WEBHOOK_RECEIVED=/netconf/system`, `NETCONF_CALLED`, `RAW_SAVED=netconf_system.xml`, `EEM_CONFIG_SAVED`, `CONFIG_BACKUP_SAVED`, `TESTING_COMPLETE`, `LAB6_END`

## Submission Checklist
- [ ] Server runs; token validation enforced on all POST endpoints.
- [ ] Five endpoints implemented and tested with cURL/Postman.
- [ ] `data/eem_config.txt` and `data/device_running_config.txt` are present.
- [ ] Artifacts saved under `data/` using specified filenames.
- [ ] `logs/lab6.log` includes all required markers.
- [ ] Pull request open to `main` before deadline.

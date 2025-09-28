#!/bin/bash
# Lab 6 - Sample cURL Test Commands
# These are example commands - students should create their own based on their implementations

echo "=== Lab 6 Webhook Testing Script ==="
echo "This script demonstrates how to test your webhook servers with cURL"
echo "Make sure your FastAPI server is running before executing these commands"
echo ""

BASE_URL="http://localhost:8000"
EVENTS_ENDPOINT="$BASE_URL/events"

echo "1. Testing basic webhook endpoint..."
curl -X POST $EVENTS_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"event": "test", "timestamp": "'$(date -Iseconds)'", "source": "curl_test"}'
echo -e "\n"

echo "2. Testing joke request webhook..."
curl -X POST $EVENTS_ENDPOINT \
  -H "Content-Type: application/json" \
  -d @data/webhook_payloads/joke_request.json
echo -e "\n"

echo "3. Testing card draw webhook..."
curl -X POST $EVENTS_ENDPOINT \
  -H "Content-Type: application/json" \
  -d @data/webhook_payloads/card_draw.json
echo -e "\n"

echo "4. Testing network device webhook..."
curl -X POST $EVENTS_ENDPOINT \
  -H "Content-Type: application/json" \
  -d @data/webhook_payloads/network_device_check.json
echo -e "\n"

echo "5. Testing error handling with malformed JSON..."
curl -X POST $EVENTS_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"invalid": "json", "missing_event"}'
echo -e "\n"

echo "6. Testing server health endpoint..."
curl -X GET $BASE_URL/health
echo -e "\n"

echo "=== Test script complete ==="
echo "Check your server logs to verify all webhooks were processed correctly"
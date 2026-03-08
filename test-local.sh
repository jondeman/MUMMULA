#!/bin/bash
# Local test: inject secrets from .env and serve

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Load .env
export $(grep -v '^#' .env | xargs)

MAPS_KEY="${GEMINI_API_KEY}"
PASSWORD="${APP_PASSWORD}"

echo "Injecting secrets into temp file..."
cp index.html /tmp/mummula_test.html
sed -i '' "s/__GOOGLE_MAPS_API_KEY__/${MAPS_KEY}/g" /tmp/mummula_test.html
sed -i '' "s/__APP_PASSWORD__/${PASSWORD}/g" /tmp/mummula_test.html

echo "APP_PASSWORD in file:"
grep "APP_PASSWORD" /tmp/mummula_test.html | head -3

echo ""
echo "Starting server at http://localhost:8080"
echo "Press Ctrl+C to stop"
cd /tmp && python3 -m http.server 8080 --bind 127.0.0.1 &
SERVER_PID=$!
sleep 1
open "http://localhost:8080/mummula_test.html"
wait $SERVER_PID

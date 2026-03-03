#!/bin/bash

# -----------------------------
# Auto-start Node.js + ngrok
# -----------------------------

SERVER_PORT=3000
NGROK_REGION=eu

# Function to start Node server
start_node() {
    echo "Starting Node.js server on port $SERVER_PORT..."
    node server.js &
    NODE_PID=$!
    echo "Node PID: $NODE_PID"
}

# Function to start ngrok
start_ngrok() {
    echo "Starting ngrok tunnel..."
    ./ngrok http $SERVER_PORT --region $NGROK_REGION --log=stdout &
    NGROK_PID=$!
    echo "ngrok PID: $NGROK_PID"

    # Wait for ngrok to initialize
    sleep 5

    # Fetch public URL
    PUBLIC_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"https[^"]*' | grep -o 'https[^"]*')

    if [ -n "$PUBLIC_URL" ]; then
        echo "✅ Your backend is publicly available at: $PUBLIC_URL"
    else
        echo "⚠️ Could not get ngrok URL. ngrok may not have started correctly."
    fi
}

# Trap to stop both processes on exit
cleanup() {
    echo "Stopping Node.js and ngrok..."
    kill $NODE_PID $NGROK_PID 2>/dev/null
    exit
}
trap cleanup SIGINT SIGTERM

# Main loop: restart if crashed
while true; do
    start_node
    start_ngrok

    # Wait until either process stops
    wait $NODE_PID
    echo "Node server crashed. Restarting in 3s..."
    kill $NGROK_PID 2>/dev/null
    sleep 3
done3o

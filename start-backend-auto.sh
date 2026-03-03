#!/bin/bash

# Start Node.js server in the background
echo "Starting Node.js server..."
node server.js &

# Give it a few seconds to start
sleep 3

# Start ngrok and show the public URL
echo "Starting ngrok tunnel..."
./ngrok http 3000 --region eu &
sleep 5

echo "Your backend should now be publicly available via ngrok."
echo "Check the ngrok web interface at http://127.0.0.1:4040"

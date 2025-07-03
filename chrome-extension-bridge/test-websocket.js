#!/usr/bin/env node

/**
 * Test WebSocket connection to the Chrome Extension Bridge Server
 */

import WebSocket from 'ws';

const serverUrl = 'ws://localhost:3000';

console.log(`🧪 Testing WebSocket connection to ${serverUrl}`);

const ws = new WebSocket(serverUrl);

ws.on('open', () => {
  console.log('✅ WebSocket connection established');
  
  // Test tools/list request
  const listRequest = {
    id: 'test-list-1',
    method: 'tools/list',
    params: {}
  };
  
  console.log('📤 Sending tools/list request:', listRequest);
  ws.send(JSON.stringify(listRequest));
  
  // Test tools/call request after a delay
  setTimeout(() => {
    const callRequest = {
      id: 'test-call-1',
      method: 'tools/call',
      params: {
        name: 'research',
        arguments: {
          query: 'Test query from WebSocket client',
          files: []
        }
      }
    };
    
    console.log('📤 Sending tools/call request:', callRequest);
    ws.send(JSON.stringify(callRequest));
  }, 1000);
});

ws.on('message', (data) => {
  try {
    const response = JSON.parse(data.toString());
    console.log('📥 Received response:', JSON.stringify(response, null, 2));
  } catch (error) {
    console.error('❌ Failed to parse response:', error);
    console.log('Raw data:', data.toString());
  }
});

ws.on('close', (code, reason) => {
  console.log(`🔌 WebSocket connection closed. Code: ${code}, Reason: ${reason}`);
  process.exit(0);
});

ws.on('error', (error) => {
  console.error('❌ WebSocket error:', error);
  process.exit(1);
});

// Close connection after 10 seconds
setTimeout(() => {
  console.log('⏰ Test timeout, closing connection');
  ws.close();
}, 10000);

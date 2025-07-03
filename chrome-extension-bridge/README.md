# Chrome Extension Bridge Server

A WebSocket bridge server that connects the Repotools Chrome Extension to the main MCP server, enabling seamless AI tool execution.

## 🎯 Purpose

The Chrome Extension Bridge Server solves the connection mismatch between:
- **Chrome Extension**: Expects WebSocket connection at `ws://localhost:3000`
- **Main MCP Server**: Uses SSE transport at `http://localhost:3001/sse`

This bridge translates WebSocket messages to the appropriate MCP server format.

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Build the Server
```bash
npm run build
```

### 3. Start the Bridge Server
```bash
npm start
```

The server will start on:
- **HTTP**: `http://localhost:3000`
- **WebSocket**: `ws://localhost:3000`
- **Health Check**: `http://localhost:3000/health`

## 🔧 Configuration

### Environment Variables
- `MCP_SERVER_URL`: URL of the main MCP server (default: `http://localhost:3001`)
- `PORT`: Bridge server port (default: `3000`)

### Example .env file
```env
MCP_SERVER_URL=http://localhost:3001
PORT=3000
```

## 📡 API Endpoints

### WebSocket Connection
- **URL**: `ws://localhost:3000`
- **Protocol**: JSON-RPC style messages

### HTTP Endpoints
- `GET /health` - Server health check
- `GET /test-mcp` - Test connection to main MCP server

## 🔌 WebSocket Protocol

### Request Format
```json
{
  "id": "unique-request-id",
  "method": "tools/call" | "tools/list",
  "params": {
    "name": "tool-name",
    "arguments": { ... }
  }
}
```

### Response Format
```json
{
  "id": "request-id",
  "result": { ... },
  "error": {
    "code": -1,
    "message": "error description"
  }
}
```

## 🛠️ Available Tools

The bridge provides access to all 14 AI development tools:

1. **research** - Research and analyze topics
2. **generate-rules** - Generate project rules and guidelines
3. **generate-prd** - Generate Product Requirements Document
4. **generate-user-stories** - Create user stories for features
5. **generate-task-list** - Generate comprehensive task lists
6. **generate-fullstack-starter-kit** - Create fullstack project templates
7. **run-workflow** - Execute automated workflows
8. **get-job-result** - Retrieve job execution results
9. **map-codebase** - Generate semantic code maps
10. **vibe-task-manager** - AI-powered task management
11. **curate-context** - Curate intelligent project context
12. **register-agent** - Register AI agents for tasks
13. **get-agent-tasks** - Retrieve tasks for agents
14. **submit-task-response** - Submit agent task responses

## 🧪 Testing

### Test WebSocket Connection
```bash
node test-websocket.js
```

### Test Tool Execution
```javascript
const ws = new WebSocket('ws://localhost:3000');

ws.on('open', () => {
  // List available tools
  ws.send(JSON.stringify({
    id: 'test-1',
    method: 'tools/list',
    params: {}
  }));
  
  // Execute a tool
  ws.send(JSON.stringify({
    id: 'test-2',
    method: 'tools/call',
    params: {
      name: 'research',
      arguments: {
        query: 'Test query',
        files: []
      }
    }
  }));
});
```

## 🔄 Integration with Chrome Extension

The Chrome Extension's MCP Bridge (`chrome-extension/src/lib/mcp-bridge.ts`) automatically connects to this server:

```typescript
// Default connection
const mcpBridge = new MCPBridge('ws://localhost:3000');

// Auto-connection on extension startup
await mcpBridge.connect();

// Execute tools
const result = await mcpBridge.executeTool('research', {
  query: 'Analyze this code',
  files: [...]
});
```

## 📊 Server Status

### Health Check Response
```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "mcpServer": "http://localhost:3001",
  "connections": 1
}
```

### Connection Logs
```
🚀 Chrome Extension Bridge Server started!
📍 HTTP Server: http://localhost:3000
🔌 WebSocket: ws://localhost:3000
🏥 Health: http://localhost:3000/health
🔗 MCP Server: http://localhost:3001

[connection-id] New WebSocket connection from Chrome extension
[connection-id] Received message: {"id":"req_1","method":"tools/call",...}
[connection-id] WebSocket connection closed
```

## 🚨 Troubleshooting

### Common Issues

1. **Port 3000 already in use**
   ```bash
   # Find process using port 3000
   lsof -i :3000
   
   # Kill the process
   kill -9 <PID>
   
   # Or use a different port
   PORT=3001 npm start
   ```

2. **Cannot connect to main MCP server**
   ```bash
   # Check if main server is running
   curl http://localhost:3001/health
   
   # Start the main MCP server
   cd .. && npm run start:sse
   ```

3. **WebSocket connection refused**
   - Ensure bridge server is running
   - Check Chrome extension console for errors
   - Verify CORS settings allow Chrome extension origin

### Debug Mode
```bash
# Enable debug logging
DEBUG=* npm start
```

## 🔧 Development

### Watch Mode
```bash
npm run dev
```

### Type Checking
```bash
npm run type-check
```

### Clean Build
```bash
npm run clean && npm run build
```

## 🏗️ Architecture

```
Chrome Extension (WebSocket) 
    ↓
Bridge Server (Port 3000)
    ↓
Main MCP Server (Port 3001, SSE)
    ↓
AI Tools (14 tools)
```

## 📝 Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with watch mode
- `npm run build` - Build TypeScript to JavaScript
- `npm run clean` - Clean build directory
- `npm run type-check` - Run TypeScript type checking

## 🔒 Security

- CORS configured for Chrome extension origins
- Request validation and error handling
- Connection timeout and cleanup
- No sensitive data logging

## 📈 Performance

- Lightweight WebSocket server
- Efficient message routing
- Connection pooling and cleanup
- Minimal memory footprint

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

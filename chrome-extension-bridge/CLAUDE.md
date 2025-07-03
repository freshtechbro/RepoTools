# Chrome Extension Bridge Server - CLAUDE.md

## Project Overview

The Chrome Extension Bridge Server is a critical middleware component that bridges the communication gap between the Repotools Chrome Extension and the main MCP (Model Context Protocol) server. This WebSocket-based server translates browser-compatible WebSocket messages into the SSE (Server-Sent Events) protocol used by the main MCP server.

### Key Architecture Components

- **WebSocket Server**: Handles real-time bidirectional communication with Chrome extension
- **HTTP Express Server**: Provides health checks and MCP server connectivity testing
- **Protocol Translation**: Converts WebSocket JSON-RPC messages to MCP server format
- **Connection Management**: Maintains active WebSocket connections and handles cleanup

## Build and Development Commands

### Essential Commands
```bash
# Install dependencies
npm install

# Build TypeScript to JavaScript
npm run build

# Start production server
npm start

# Development with watch mode and auto-restart
npm run dev

# Type checking without compilation
npm run type-check

# Clean build artifacts
npm run clean
```

### Development Workflow
```bash
# 1. Start in development mode
npm run dev

# 2. Test WebSocket connection
node test-websocket.js

# 3. Verify health endpoint
curl http://localhost:3000/health

# 4. Test MCP server connectivity
curl http://localhost:3000/test-mcp
```

## Architecture Overview

### WebSocket-to-MCP Translation Flow

```
Chrome Extension (WebSocket Client)
        ↓ JSON-RPC Messages
WebSocket Server (Port 3000)
        ↓ Protocol Translation
HTTP/SSE Client → Main MCP Server (Port 3001)
        ↓ Tool Execution
AI Tools (14 Available Tools)
```

### Core Classes and Interfaces

#### `ChromeExtensionBridge` Class
- **Purpose**: Main server class managing WebSocket and HTTP servers
- **Key Methods**:
  - `setupExpress()`: Configures CORS and HTTP endpoints
  - `setupWebSocket()`: Handles WebSocket connections and message routing
  - `handleMCPRequest()`: Routes tool requests to appropriate handlers
  - `executeToolViaMCP()`: Translates and forwards tool calls to main MCP server

#### Message Interfaces
```typescript
interface MCPRequest {
  id: string;
  method: string;
  params: Record<string, any>;
}

interface MCPResponse {
  id: string;
  result?: any;
  error?: { code: number; message: string; data?: any };
}
```

## Key Files and Their Purposes

### `/src/index.ts`
- **Purpose**: Main server implementation with WebSocket and HTTP handling
- **Key Features**:
  - WebSocket connection management with unique connection IDs
  - CORS configuration for Chrome extension origins
  - Tool execution routing and response handling
  - Graceful shutdown handling

### `/package.json`
- **Dependencies**: Express, WebSocket (ws), CORS, Axios, UUID, EventSource
- **Scripts**: Build, start, development, and maintenance commands
- **Engine Requirements**: Node.js >=18.0.0

### `/test-websocket.js`
- **Purpose**: Integration test script for WebSocket functionality
- **Features**: Tests both `tools/list` and `tools/call` methods
- **Usage**: `node test-websocket.js`

### `/tsconfig.json`
- **Configuration**: Strict TypeScript compilation settings
- **Target**: ES2022 with ESNext modules
- **Output**: Generates declaration files and source maps

## Communication Protocols and Message Handling

### WebSocket Protocol (Chrome Extension → Bridge)

#### Connection Flow
1. Chrome extension connects to `ws://localhost:3000`
2. Server assigns unique connection ID
3. Server sends welcome message with connection details
4. Client can send tool requests using JSON-RPC format

#### Request Methods
- **`tools/list`**: Returns available AI tools
- **`tools/call`**: Executes specific tool with parameters

#### Message Format
```json
{
  "id": "unique-request-id",
  "method": "tools/call",
  "params": {
    "name": "research",
    "arguments": {
      "query": "Analyze this code",
      "files": ["path/to/file.js"]
    }
  }
}
```

### HTTP Protocol (Bridge → Main MCP Server)

#### Integration Points
- **Health Check**: `GET /health` - Server status and connection count
- **MCP Test**: `GET /test-mcp` - Validates connection to main MCP server
- **Tool Execution**: Uses Axios for HTTP requests and EventSource for SSE

## Available Tools

The bridge provides access to 14 AI development tools:

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

## Development Workflow and Debugging

### Setting Up Development Environment

```bash
# 1. Install dependencies
npm install

# 2. Start development server (auto-restart on changes)
npm run dev

# 3. In another terminal, test functionality
node test-websocket.js
```

### Debugging Steps

1. **Check Server Health**
   ```bash
   curl http://localhost:3000/health
   ```

2. **Test MCP Server Connection**
   ```bash
   curl http://localhost:3000/test-mcp
   ```

3. **WebSocket Connection Testing**
   ```bash
   node test-websocket.js
   ```

4. **Monitor Server Logs**
   - Connection establishment: `[connection-id] New WebSocket connection`
   - Message processing: `[connection-id] Received message`
   - Tool execution: `Executing tool: toolName with args`

### Common Issues and Solutions

1. **Port 3000 in use**: Change port with `PORT=3001 npm start`
2. **MCP server connection failed**: Ensure main server is running on port 3001
3. **WebSocket connection refused**: Check CORS configuration and browser console
4. **Tool execution timeout**: Verify main MCP server is responding

## Integration Points

### Chrome Extension Integration
- **Connection URL**: `ws://localhost:3000`
- **Protocol**: JSON-RPC over WebSocket
- **Auto-reconnection**: Handled by Chrome extension MCP bridge
- **Tool Execution**: Seamless integration with extension UI

### Main MCP Server Integration
- **Server URL**: `http://localhost:3001` (configurable via `MCP_SERVER_URL`)
- **Protocol**: HTTP/SSE for tool execution
- **Health Check**: Regular connectivity validation
- **Session Management**: UUID-based session identification

## Common Development Tasks

### Adding New Tool Support
1. Update `handleToolsList()` method to include new tool
2. Modify `executeToolViaMCP()` for tool-specific handling
3. Test using `test-websocket.js` script

### Modifying WebSocket Protocol
1. Update `MCPRequest` or `MCPResponse` interfaces
2. Modify `handleMCPRequest()` message routing
3. Update Chrome extension bridge accordingly

### Enhancing Error Handling
1. Add specific error codes in `sendError()` method
2. Implement retry logic in `executeToolViaMCP()`
3. Add logging for debugging scenarios

### Performance Optimization
1. Implement connection pooling for MCP server requests
2. Add request caching for frequently used tools
3. Optimize message serialization/deserialization

## Environment Configuration

### Environment Variables
```bash
# Main MCP server URL
MCP_SERVER_URL=http://localhost:3001

# Bridge server port
PORT=3000

# Enable debug logging
DEBUG=*
```

### Production Deployment
```bash
# Build for production
npm run build

# Start production server
npm start

# Health check
curl http://localhost:3000/health
```

## Security Considerations

- **CORS Policy**: Restricted to Chrome extension origins
- **Input Validation**: JSON message parsing with error handling
- **Connection Limits**: Active connection tracking and cleanup
- **No Sensitive Logging**: Avoids logging sensitive tool parameters

## Performance Metrics

- **Connection Handling**: Efficient WebSocket connection management
- **Memory Usage**: Lightweight with minimal memory footprint
- **Response Time**: Low-latency message routing
- **Concurrent Connections**: Supports multiple Chrome extension instances

This bridge server is essential for the Repotools Chrome Extension ecosystem, providing reliable and efficient communication between the browser environment and the AI-powered backend services.
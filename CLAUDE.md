# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RepoTools is a production-ready Model Context Protocol (MCP) server that provides AI-driven development tools through a unified interface. The system supports multiple transport mechanisms (stdio, SSE, WebSocket, HTTP), asynchronous job processing, and intelligent codebase analysis.

## Build and Development Commands

### Core Commands
```bash
# Install dependencies (root and sub-projects)
npm install
cd chrome-extension && npm install && cd ..
cd chrome-extension-bridge && npm install && cd ..
cd lightweight-server && npm install && cd ..

# Build commands
npm run build                    # Build main MCP server
npm run build:prod              # Production build
cd chrome-extension && npm run build && cd ..
cd chrome-extension-bridge && npm run build && cd ..

# Development
npm run dev                     # Watch mode with pretty logs
npm run dev:sse                 # SSE transport dev mode

# Start server
npm start                       # Production stdio mode
npm run start:sse              # Production SSE mode

# Testing
npm test                        # Run all tests excluding e2e
npm run test:unit              # Unit tests only
npm run test:integration       # Integration tests only
npm run test:e2e               # E2E tests with mock mode
npm run test:e2e:real          # E2E tests with real APIs
npm run test:watch             # Watch mode for tests
npm run coverage               # Generate coverage report

# Linting and type checking
npm run lint                    # ESLint
npm run type-check             # TypeScript type checking

# Chrome extension specific
cd chrome-extension
npm run dev                     # Watch mode for extension
npm run icons                   # Generate extension icons
npm run setup                   # Full setup including icons and build
```

### Running a Single Test
```bash
# Run specific test file
npx vitest run src/tools/vibe-task-manager/__tests__/index.test.ts

# Run tests matching pattern
npx vitest run -t "should create project"

# Debug mode
npx vitest run --reporter=verbose src/path/to/test.ts
```

## High-Level Architecture

### Core Components

1. **Transport Layer** (`src/index.ts`)
   - Supports stdio (default), SSE, WebSocket, and HTTP transports
   - Session management per transport type
   - Unified message handling across all transports

2. **MCP Server Core** (`src/server.ts`)
   - Dynamic tool registration from Tool Registry
   - Session state management
   - Security configuration initialization

3. **Tool Registry** (`src/services/routing/toolRegistry.ts`)
   - Singleton pattern for centralized tool management
   - Self-registering tools via imports
   - Unified execution interface with context passing

4. **Job Management** (`src/services/job-manager/`)
   - Asynchronous job processing with status tracking
   - Rate-limited polling with exponential backoff
   - SSE notifications for real-time updates

5. **Security Architecture**
   - Separate read/write directory boundaries
   - Path validation and permission checking
   - Configurable security modes (strict by default)

### Tool Ecosystem

1. **Vibe Task Manager** (`src/tools/vibe-task-manager/`)
   - Natural language processing with intent recognition
   - Recursive Decomposition Design (RDD) for project breakdown
   - Multi-agent coordination support
   - Real file storage (no mocks)

2. **Context Curator** (`src/tools/context-curator/`)
   - 8-phase workflow pipeline for intelligent context packaging
   - Language-agnostic project detection (35+ languages)
   - Intelligent codemap caching system
   - Multi-strategy file discovery

3. **Code Map Generator** (`src/tools/code-map-generator/`)
   - Tree-sitter based parsing for 30+ languages
   - Import resolution with adapter architecture
   - Memory optimization with LRU caching
   - 95-97% token reduction achieved

4. **Chrome Extension Integration**
   - Bridge server translates WebSocket to MCP SSE protocol
   - 14 AI tools accessible through browser interface
   - Real-time progress tracking
   - Side panel for detailed tool configuration

### Configuration System

- **Environment Variables**: `.env` file with API keys and paths
- **LLM Configuration**: `llm_config.json` maps tasks to specific models
- **MCP Configuration**: `mcp-config.json` defines tool patterns
- **Security Boundaries**:
  - `CODE_MAP_ALLOWED_DIR`: Read access for code analysis
  - `VIBE_CODER_OUTPUT_DIR`: Write access for generated files
  - `VIBE_TASK_MANAGER_READ_DIR`: Task manager file access

### Critical Patterns

1. **Job Polling Protocol**
   - Tools return Job IDs for async operations
   - MUST poll using `get-job-result` until completion
   - Never generate content while waiting
   - Exponential backoff for rate limiting

2. **Tool Registration**
   - Tools self-register via `registerTool()` in their index files
   - Registry provides unified interface for all tools
   - Configuration passed through context at execution

3. **Session Management**
   - stdio: Fixed `stdio-session` ID
   - SSE/WebSocket: Dynamic session IDs per connection
   - Context preserved across tool calls within session

4. **Error Handling**
   - Comprehensive error types in `src/utils/errors.ts`
   - Job failures tracked with detailed diagnostics
   - Graceful degradation for missing tools

## Chrome Extension Architecture

The Chrome extension provides a browser-based interface to the MCP server:

1. **Components**:
   - Popup: Quick tool selection interface
   - Side Panel: Detailed parameter configuration and results
   - Content Scripts: GitHub integration for context-aware suggestions
   - Service Worker: Background communication handling

2. **Bridge Server** (`chrome-extension-bridge/`):
   - Runs on port 3000 by default
   - Translates WebSocket messages to MCP server format
   - Handles tool execution and result streaming

3. **Communication Flow**:
   ```
   Chrome Extension (WebSocket) → Bridge Server → MCP Server (SSE) → Tools
   ```

## Important Implementation Details

1. **Zero Mock Policy**: All integrations are production-ready with real implementations
2. **Memory Management**: Sophisticated caching and lazy loading for large codebases
3. **Performance Targets**: <200ms response for sync operations, <400MB memory usage
4. **Test Coverage**: 99.8% success rate across 2000+ tests
5. **Natural Language**: 6 core intents with pattern matching + LLM fallback

## Common Development Tasks

### Adding a New Tool
1. Create directory in `src/tools/your-tool-name/`
2. Implement tool with `registerTool()` call
3. Add to imports in `src/tools/index.ts`
4. Tool auto-registers with MCP server

### Debugging Job Processing
1. Check job status with enhanced diagnostics
2. Monitor SSE endpoint `/events/:sessionId` for real-time updates
3. Review job manager logs for polling patterns
4. Verify rate limiting isn't blocking progress

### Chrome Extension Development
1. Run bridge server: `cd chrome-extension-bridge && npm start`
2. Run MCP server with SSE: `npm run start:sse`
3. Load unpacked extension from `chrome-extension/dist`
4. Check DevTools console for connection status

## System Instructions Integration

The `VIBE_CODER_MCP_SYSTEM_INSTRUCTIONS.md` file contains comprehensive guidance for AI agents. Key points:

- Mandatory job polling protocol
- Tool-specific usage patterns
- Natural language command structures
- Integration workflows
- Error handling strategies

This file should be added to your MCP client's system instructions for optimal tool usage.
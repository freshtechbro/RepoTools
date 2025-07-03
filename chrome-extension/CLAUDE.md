# Chrome Extension CLAUDE.md

## Project Overview

This Chrome extension integrates AI-powered development tools directly into the browser, providing seamless access to 14 specialized MCP tools through a modern glass-morphism interface. The extension features a popup interface, side panel, and GitHub integration for context-aware development workflows.

## Architecture Overview

### Core Components

1. **Extension Pages**
   - **Popup** (`popup/popup.tsx`): Quick tool selection and execution (480x700px)
   - **Side Panel** (`sidepanel/sidepanel.tsx`): Full-screen interface with detailed tool interaction
   - **Options** (`options/options.tsx`): Extension configuration and settings

2. **Background Services**
   - **Service Worker** (`src/background/service-worker.ts`): Manages extension lifecycle, messaging, and task coordination
   - **Task Management**: Real-time progress tracking and inter-component communication

3. **Content Integration**
   - **GitHub Integration** (`src/content/github-integration.ts`): Context-aware tool suggestions on GitHub pages
   - **Repository Detection**: Automatic repo info extraction and floating panel injection

4. **MCP Communication**
   - **MCP Bridge** (`src/lib/mcp-bridge.ts`): WebSocket-based communication with local MCP server
   - **Connection Management**: Auto-reconnection, timeout handling, and error recovery

### Data Flow

```
GitHub Page → Content Script → Background Service Worker → MCP Bridge → Local MCP Server
                                      ↓
Popup/Side Panel ← Extension Storage ← Task Management ← Tool Execution Results
```

## Key Features

### 14 AI Tools Available:
- **Research**: Research and analyze topics
- **Generate Rules**: Generate project rules and guidelines
- **Generate PRD**: Generate Product Requirements Document
- **Generate User Stories**: Create user stories for features
- **Generate Task List**: Generate comprehensive task lists
- **Generate Fullstack Starter Kit**: Create fullstack project templates
- **Run Workflow**: Execute automated workflows
- **Get Job Result**: Retrieve job execution results
- **Map Codebase**: Generate semantic code maps
- **Vibe Task Manager**: AI-powered task management
- **Curate Context**: Curate intelligent project context
- **Register Agent**: Register AI agents for tasks
- **Get Agent Tasks**: Retrieve tasks for agents
- **Submit Task Response**: Submit agent task responses

### UI/UX Design
- **Glass Morphism**: Modern design with backdrop blur and transparency
- **Responsive Layout**: Optimized for both popup and side panel contexts
- **File Attachment**: Support for multi-file uploads with tool execution
- **Real-time Status**: Live connection status and execution progress
- **Shadcn/UI Components**: Consistent, accessible component library

## Development Workflow

### Setup Commands
```bash
# Initial setup
npm install
npm run icons
npm run build

# Development (watch mode)
npm run dev

# Full development build
npm run dev:full

# Production build
npm run build:prod

# Type checking
npm run type-check

# Linting
npm run lint

# Testing
npm run test
npm run test:watch
```

### Build System (Vite)
- **Multi-entry build**: Separate bundles for popup, sidepanel, options, background, and content scripts
- **TypeScript support**: Full type checking with Chrome extension APIs
- **Asset optimization**: Automatic icon generation and resource copying
- **Development server**: Watch mode for rapid development
- **Production optimization**: Minification with Terser, console removal

### Extension Loading
1. Build the extension: `npm run build`
2. Open Chrome: `chrome://extensions/`
3. Enable "Developer mode"
4. Click "Load unpacked" and select the `dist` folder

## Component Structure

### Shared Components (`src/components/ui/`)
- **Button**: Primary action buttons with glass styling
- **Card**: Container components with backdrop blur
- **Input**: Form inputs with glass morphism
- **Select**: Dropdown selectors for tool selection
- **Textarea**: Multi-line text inputs for output display
- **Progress**: Task progress indicators
- **Tabs**: Tabbed interface components
- **Switch**: Toggle switches for settings

### Styling System
- **TailwindCSS**: Utility-first CSS framework
- **Custom Glass Classes**: `.glass-card`, `.glass-panel`, `.glass-button`
- **Animation Support**: Fade-in, scale-in, glass shimmer effects
- **Responsive Design**: Mobile-first approach with extension-specific breakpoints

## MCP Integration

### Connection Management
```typescript
// Auto-connection on startup
const mcpBridge = new MCPBridge('ws://localhost:3000');
await mcpBridge.connect();

// Tool execution
const result = await mcpBridge.executeTool('research', {
  query: 'Analyze authentication patterns',
  files: attachedFiles
});
```

### Message Protocol
- **Request Format**: JSON-RPC 2.0 compatible
- **Response Handling**: Promise-based with timeout support
- **Error Recovery**: Automatic reconnection with exponential backoff
- **Job Management**: Long-running task monitoring via job IDs

## Configuration

### Extension Manifest (`manifest.json`)
- **Manifest Version**: 3
- **Permissions**: `storage`, `activeTab`, `scripting`, `tabs`, `sidePanel`
- **Host Permissions**: GitHub.com, localhost (for MCP server)
- **CSP**: Allows WebSocket connections to localhost

### TypeScript Configuration
- **Target**: ES2020 with DOM support
- **Module System**: ESNext with bundler resolution
- **Path Aliases**: `@/*` for src directory
- **Types**: Chrome extension APIs, Vite, Node.js

## Testing Strategy

### Test Setup
- **Jest**: Testing framework with Chrome extension mocks
- **Test Scripts**: `test-setup.js`, `test-sidepanel.js`
- **Coverage**: Component testing, integration testing
- **Manual Testing**: Extension loading, tool execution, GitHub integration

### Testing Checklist
- [ ] Popup interface loads correctly
- [ ] Side panel communication works
- [ ] MCP server connection established
- [ ] Tool execution completes successfully
- [ ] GitHub integration detects repositories
- [ ] File attachments work properly
- [ ] Error handling functions correctly

## Common Development Tasks

### Adding New Tools
1. Update tool list in `popup/popup.tsx` and `sidepanel/sidepanel.tsx`
2. Add icon from Lucide React
3. Update MCP bridge if new parameters needed
4. Test tool execution in both popup and side panel

### Updating UI Components
1. Modify components in `src/components/ui/`
2. Update TailwindCSS classes if needed
3. Test glass morphism effects
4. Ensure accessibility compliance

### Debugging Extension
1. Check browser console for errors
2. Use Chrome DevTools for extension pages
3. Monitor WebSocket connections in Network tab
4. Review extension logs in `chrome://extensions/`

### GitHub Integration Updates
1. Modify `src/content/github-integration.ts`
2. Update repository detection logic
3. Test on various GitHub page types
4. Ensure floating panel styling works

## Performance Optimization

### Bundle Analysis
- **Entry Points**: 5 separate bundles (popup, sidepanel, options, background, content)
- **Code Splitting**: Automatic chunk splitting for shared dependencies
- **Asset Optimization**: Icon generation, CSS extraction
- **Tree Shaking**: Unused code elimination

### Runtime Performance
- **Lazy Loading**: Components loaded on demand
- **Memory Management**: Proper cleanup of WebSocket connections
- **Caching**: Chrome storage for settings and connection state
- **Error Suppression**: Graceful handling of ResizeObserver errors

## Security Considerations

### Content Security Policy
- **Script Sources**: 'self' and 'wasm-unsafe-eval' only
- **Connect Sources**: Localhost for MCP server communication
- **No Eval**: Strict CSP prevents code injection

### Data Handling
- **Local Storage**: Sensitive data stored in Chrome extension storage
- **File Uploads**: Client-side file handling with size limits
- **Network**: Secure WebSocket connections to localhost only

## Integration Points

### MCP Bridge Server
- **Location**: `../chrome-extension-bridge/`
- **Protocol**: WebSocket with JSON-RPC 2.0
- **Authentication**: Token-based (future implementation)
- **Rate Limiting**: Request throttling on server side

### Parent Repository
- **Shared Types**: Common interfaces with main MCP implementation
- **Build Integration**: Coordinated builds with parent project
- **Tool Compatibility**: Maintains compatibility with existing MCP tools

## Troubleshooting Guide

### Common Issues
1. **Connection Failed**: Ensure MCP bridge server is running on port 3000
2. **Tool Execution Timeout**: Increase timeout in extension options
3. **Build Errors**: Clear node_modules and reinstall dependencies
4. **GitHub Integration Not Working**: Check content script injection
5. **Side Panel Not Opening**: Verify Chrome version supports side panel API

### Debug Mode
Enable verbose logging in extension options:
```javascript
{
  "debug": true,
  "logLevel": "verbose",
  "serverUrl": "ws://localhost:3000"
}
```

### Development Tips
- Use `npm run dev` for watch mode during development
- Load extension from `dist` folder after each build
- Check Chrome extension console for runtime errors
- Use Chrome DevTools for debugging extension pages
- Test in incognito mode to verify clean state

## Future Enhancements

### Planned Features
- **Authentication**: User authentication for cloud features
- **Team Collaboration**: Shared tool configurations
- **Custom Tools**: User-defined tool creation
- **Offline Mode**: Cached tool execution
- **Export/Import**: Configuration backup and restore

### Technical Improvements
- **Performance**: Further bundle optimization
- **Security**: Enhanced CSP and permissions
- **Accessibility**: ARIA labels and keyboard navigation
- **Testing**: Automated E2E testing suite
- **Documentation**: Interactive help system
# RepoTools Chrome Extension

A powerful Chrome extension that brings AI-powered development tools directly to your browser. RepoTools integrates with a local MCP server to provide advanced code analysis, generation, and management capabilities.

## 🚀 Features

### 14 Powerful AI Tools

1. **Research** - Research and analyze topics with AI assistance
2. **Generate Rules** - Generate project rules and coding guidelines
3. **Generate PRD** - Create comprehensive Product Requirements Documents
4. **Generate User Stories** - Generate user stories for feature development
5. **Generate Task List** - Create detailed task breakdowns
6. **Generate Fullstack Starter Kit** - Bootstrap complete project templates
7. **Run Workflow** - Execute automated development workflows
8. **Get Job Result** - Retrieve and monitor job execution results
9. **Map Codebase** - Generate semantic code maps and documentation
10. **Vibe Task Manager** - AI-powered task management and orchestration
11. **Curate Context** - Intelligent project context curation
12. **Register Agent** - Register AI agents for automated tasks
13. **Get Agent Tasks** - Retrieve tasks assigned to AI agents
14. **Submit Task Response** - Submit responses from AI agent execution

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Chrome         │    │  Local MCP       │    │  External APIs  │
│  Extension      │◄──►│  Server          │◄──►│  (OpenRouter,   │
│                 │    │  (WebSocket)     │    │   etc.)         │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Components

- **Chrome Extension**: Modern React-based UI with glass design
- **Local MCP Server**: Lightweight server for tool execution
- **WebSocket Bridge**: Real-time communication layer
- **Tool Adapters**: Seamless integration with existing MCP tools

## 🛠️ Installation

### Prerequisites

- Node.js 18+ 
- Chrome Browser
- Local MCP server running

### Development Setup

1. **Clone and Install Dependencies**
   ```bash
   cd chrome-extension
   npm install
   ```

2. **Build the Extension**
   ```bash
   npm run build
   ```

3. **Load in Chrome**
   - Open Chrome and go to `chrome://extensions/`
   - Enable "Developer mode"
   - Click "Load unpacked" and select the `dist` folder

4. **Start Local Server**
   ```bash
   cd ../lightweight-server
   npm install
   npm run build
   npm start
   ```

## 🎯 Usage

### Basic Workflow

1. **Open Extension**: Click the RepoTools icon in Chrome toolbar
2. **Check Connection**: Verify connection to local MCP server
3. **Select Tool**: Choose from 14 available AI tools
4. **Configure Parameters**: Set tool-specific parameters in side panel
5. **Execute & Monitor**: Run tools and monitor progress in real-time
6. **View Results**: Access generated outputs and download results

### Tool Categories

#### **Client-Side Tools** (Fast execution)
- Generate Rules
- Generate PRD  
- Generate User Stories
- Generate Task List

#### **Server-Side Tools** (Advanced processing)
- Map Codebase
- Vibe Task Manager
- Curate Context
- Research

#### **Agent Tools** (AI coordination)
- Register Agent
- Get Agent Tasks
- Submit Task Response

#### **Workflow Tools** (Orchestration)
- Run Workflow
- Get Job Result

## 🔧 Configuration

### Server Connection

The extension connects to `ws://localhost:3000` by default. Configure in extension options:

```javascript
{
  "serverUrl": "ws://localhost:3000",
  "reconnectAttempts": 5,
  "timeout": 30000
}
```

### Tool Parameters

Each tool accepts specific parameters. Examples:

```javascript
// Code Map Generator
{
  "targetDirectory": "./src",
  "outputFormat": "markdown",
  "includeTests": true
}

// Context Curator  
{
  "prompt": "Analyze authentication system",
  "maxTokens": 250000,
  "taskType": "feature_addition"
}
```

## 🎨 UI Components

### Popup Interface
- **Tool Grid**: Visual tool selection with icons
- **Connection Status**: Real-time server connection indicator
- **Quick Actions**: Fast access to common operations

### Side Panel
- **Parameter Forms**: Dynamic forms for tool configuration
- **Progress Tracking**: Real-time execution monitoring
- **Results Display**: Formatted output with export options

### Content Scripts
- **GitHub Integration**: Context-aware tool suggestions
- **Code Selection**: Direct tool execution on selected code

## 🔒 Security

### Extension Security
- Content Security Policy compliance
- Minimal permissions model
- Secure localhost communication
- Input validation and sanitization

### Server Security
- Localhost-only binding
- Request rate limiting
- File system access restrictions
- Authentication tokens

## ���� Development

### Build Commands

```bash
# Development build with watch
npm run dev

# Production build
npm run build:prod

# Type checking
npm run type-check

# Linting
npm run lint

# Testing
npm run test
```

### Project Structure

```
chrome-extension/
├── manifest.json          # Extension manifest
├── popup/                 # Popup interface
│   ├── popup.tsx         # Main popup component
│   └── index.html        # Popup HTML
├── src/
│   ├── components/       # Reusable UI components
│   ├── lib/             # Utilities and services
│   │   ├── mcp-bridge.ts # MCP communication layer
│   │   └── utils.ts     # Extension utilities
│   ├── background/      # Service worker
│   ├── content/         # Content scripts
│   └── styles/          # Global styles
├── sidepanel/           # Side panel interface
├── options/             # Extension options
└── dist/               # Built extension
```

## 📊 Performance

- **Startup Time**: < 200ms
- **Tool Execution**: Varies by complexity
- **Memory Usage**: ~50MB average
- **Network**: WebSocket for real-time updates

## 🐛 Troubleshooting

### Common Issues

1. **Connection Failed**
   - Ensure local server is running on port 3000
   - Check firewall settings
   - Verify WebSocket support

2. **Tool Execution Timeout**
   - Increase timeout in extension options
   - Check server logs for errors
   - Verify tool parameters

3. **Build Errors**
   - Clear node_modules and reinstall
   - Check TypeScript version compatibility
   - Verify all dependencies are installed

### Debug Mode

Enable debug logging in extension options:

```javascript
{
  "debug": true,
  "logLevel": "verbose"
}
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request

## 📄 License

MIT License - see LICENSE file for details

## 🔗 Links

- **🌐 Official Website**: https://repotools.ai
- **📚 Documentation**: https://docs.repotools.ai
- **🔧 API Reference**: https://api.repotools.ai
- **💬 Community**: https://community.repotools.ai
- **🐛 Support & Issues**: https://github.com/freshtechbro/repotools/issues

---

**RepoTools** - Empowering developers with AI-powered tools, directly in the browser.

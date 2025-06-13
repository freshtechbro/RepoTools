# RepoTools - AI-Powered Development Tools

![Test](https://github.com/freshtechbro/RepoTools/actions/workflows/test.yml/badge.svg)

**RepoTools** brings powerful AI development tools directly to your browser through a modern Chrome extension, built on the robust Vibe-Coder-MCP server architecture. Get instant access to 14 AI-powered tools for code analysis, generation, and project management.

> 🚀 **Chrome Extension** + 🛠️ **MCP Server** = Complete AI Development Toolkit
> 
> 🌐 **Official Website**: [repotools.ai](https://repotools.ai)

---

## 🎯 For Users: Chrome Extension

### ✨ **14 Powerful AI Tools at Your Fingertips**

Transform your development workflow with AI tools accessible directly from your browser:

1. **🔍 Research** - AI-powered topic research and analysis
2. **📋 Generate Rules** - Create project guidelines and coding standards
3. **📄 Generate PRD** - Comprehensive Product Requirements Documents
4. **📖 Generate User Stories** - Feature development user stories
5. **✅ Generate Task List** - Detailed project task breakdowns
6. **🚀 Generate Fullstack Starter Kit** - Complete project templates
7. **⚡ Run Workflow** - Automated development workflows
8. **📊 Get Job Result** - Monitor and retrieve job execution results
9. **🗺️ Map Codebase** - Generate semantic code maps and documentation
10. **🎯 Vibe Task Manager** - AI-powered task orchestration
11. **🧠 Curate Context** - Intelligent project context analysis
12. **🤖 Register Agent** - AI agent registration for automation
13. **📋 Get Agent Tasks** - Retrieve AI agent task assignments
14. **✅ Submit Task Response** - Submit AI agent execution results

### 🏗️ **Architecture Overview**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Chrome         │    │  Local MCP       │    │  External APIs  │
│  Extension      │◄──►│  Server          │◄──�������│  (OpenRouter,   │
│  (RepoTools)    │    │  (Vibe-Coder)    │    │   Perplexity)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 🛠️ **Quick Installation**

#### **Prerequisites**
- Node.js 18+
- Chrome Browser
- Local MCP server running

#### **1. Install Chrome Extension**
```bash
# Clone and build extension
cd chrome-extension
npm install
npm run build

# Load in Chrome
# 1. Open chrome://extensions/
# 2. Enable "Developer mode"
# 3. Click "Load unpacked" → select dist/ folder
```

#### **2. Start Local Server**
```bash
# Start the MCP server
npm install
npm run build
npm start

# Start lightweight server (for Chrome extension)
cd lightweight-server
npm install
npm start
```

### 🎯 **Usage Workflow**

1. **🔗 Connect**: Extension auto-connects to `ws://localhost:3000`
2. **🎨 Select Tool**: Choose from 14 AI tools in the popup interface
3. **⚙️ Configure**: Set parameters in the sidepanel
4. **🚀 Execute**: Run tools with real-time progress tracking
5. **📥 Results**: View, export, and manage generated outputs

### 🎨 **Modern UI Components**

- **🎪 Popup Interface**: Quick tool access with visual grid
- **📱 Side Panel**: Advanced parameter configuration
- **⚙️ Options Page**: Extension settings and preferences
- **🔄 Real-time Updates**: WebSocket-powered progress tracking
- **🎯 GitHub Integration**: Context-aware suggestions

---

## 🔧 For Developers: MCP Server & Technical Architecture

RepoTools is built on the powerful **Vibe-Coder-MCP** server architecture, providing enterprise-grade AI development tools through multiple transport protocols.

### 🚀 **Core Architecture**

#### **Multi-Transport Support**
- **stdio**: Direct MCP client integration (Claude Desktop, Cursor, Cline)
- **WebSocket**: Real-time Chrome extension communication
- **HTTP**: RESTful API access
- **SSE**: Server-sent events for streaming

#### **Advanced Features**
- **🧠 Semantic Request Routing**: Embedding-based intelligent request routing
- **🏗️ Tool Registry Architecture**: Self-registering, modular tool system
- **🔄 Session State Management**: Persistent context across requests
- **⚡ Asynchronous Execution**: Job-based processing with real-time status
- **🛡️ Security Boundaries**: Separate read/write path validation

### 🧠 **AI-Native Task Management**

#### **Vibe Task Manager**
- **📊 Production Ready**: 99.8% test success rate
- **🗣️ Natural Language Processing**: 6 core intents with multi-strategy recognition
- **🔄 Recursive Decomposition Design (RDD)**: Intelligent project breakdown
- **🤖 Agent Orchestration**: Multi-agent coordination with load balancing
- **💾 Real Storage Integration**: Zero mock code policy

#### **Task Management Features**
```typescript
// Example: Task decomposition
{
  "project": "E-commerce Platform",
  "epics": 12,
  "tasks": 60,
  "subtasks": 300,
  "agents": 8,
  "completion": "real-time tracking"
}
```

### 🔍 **Advanced Code Analysis**

#### **Code Map Generator**
- **🌐 35+ Languages**: Comprehensive programming language support
- **🎯 95-97% Token Reduction**: Optimized for AI consumption
- **📊 Mermaid Diagrams**: Visual architecture representations
- **🔗 Import Resolution**: Third-party dependency mapping
- **⚡ Intelligent Caching**: Configurable codemap reuse

#### **Context Curator**
- **🎯 Language-Agnostic**: 95%+ accuracy across 35+ languages
- **📋 8-Phase Workflow**: Comprehensive project analysis pipeline
- **🧠 AI-Optimized Output**: 250,000 token budget with smart chunking
- **🔄 Multi-Format Support**: XML, JSON, YAML output formats

### 📋 **Research & Planning Suite**

#### **Research Manager**
- **🔍 Deep Research**: Perplexity Sonar integration via OpenRouter
- **📄 Document Generation**: PRDs, user stories, task lists, development rules
- **🚀 Project Scaffolding**: Dynamic full-stack starter kit generation
- **⚡ Workflow Execution**: Predefined tool sequences via `workflows.json`

#### **Performance Metrics**
- **⚡ Response Time**: <200ms average
- **💾 Memory Usage**: <400MB operational
- **🧪 Test Coverage**: 99.8% success rate (3,549+ tests)
- **🔒 Security**: TruffleHog integration, zero secrets exposure

### 🛠️ **Development Setup**

#### **Environment Configuration**
```bash
# Core MCP Server
npm install
npm run build
npm test                    # 99.8% success rate
npm run lint               # TypeScript strict mode

# Chrome Extension
cd chrome-extension
npm install
npm run build
npm run dev                # Development with hot reload

# Lightweight Server
cd lightweight-server
npm install
npm run build
npm start                  # WebSocket server on :3000
```

#### **Configuration Files**
- **`llm_config.json`**: LLM provider settings (OpenRouter, etc.)
- **`mcp-config.json`**: MCP server configuration
- **`workflows.json`**: Predefined tool execution sequences
- **`.env`**: Environment variables and API keys

### 🔌 **API Integration**

#### **MCP Protocol**
```typescript
// Tool execution via MCP
{
  "method": "tools/call",
  "params": {
    "name": "code-map-generator",
    "arguments": {
      "targetDirectory": "./src",
      "outputFormat": "markdown",
      "includeTests": true
    }
  }
}
```

#### **WebSocket API (Chrome Extension)**
```typescript
// Real-time tool execution
const ws = new WebSocket('ws://localhost:3000');
ws.send(JSON.stringify({
  "tool": "vibe-task-manager",
  "params": {
    "prompt": "Create e-commerce platform",
    "complexity": "high"
  }
}));
```

#### **HTTP REST API**
```bash
# File operations
POST /api/files/read
POST /api/files/write

# Task management
POST /api/tasks/create
GET /api/tasks/status/:id

# System information
GET /api/system/health
GET /api/system/tools
```

### 🏗️ **Architecture Patterns**

#### **Tool Registry System**
```typescript
// Self-registering tools
export class CodeMapGenerator implements MCPTool {
  name = 'code-map-generator';
  description = 'Generate semantic code maps';
  
  async execute(params: CodeMapParams): Promise<CodeMapResult> {
    // Implementation
  }
}
```

#### **Security Architecture**
- **🔒 Path Validation**: `createSecurePath()` and `validatePathSecurity()`
- **📁 Directory Restrictions**: Read from `VIBE_TASK_MANAGER_READ_DIR`
- **💾 Output Isolation**: Write to `VIBE_CODER_OUTPUT_DIR` only
- **🛡️ Input Sanitization**: All user inputs validated and sanitized

### 📊 **Monitoring & Observability**

#### **Health Monitoring**
```typescript
// System health endpoint
{
  "status": "healthy",
  "uptime": "2h 34m",
  "memory": "245MB",
  "tools": 14,
  "activeJobs": 3,
  "completedJobs": 127
}
```

#### **Performance Tracking**
- **📈 Tool Execution Times**: Per-tool performance metrics
- **💾 Memory Usage**: Real-time memory monitoring
- **🔄 Job Queue Status**: Active and completed job tracking
- **⚡ WebSocket Connections**: Real-time connection monitoring

---

## 📚 **Complete Tool Documentation**

### 🔍 **Research Tools**

#### **Research Manager**
- **Purpose**: Deep research using Perplexity Sonar via OpenRouter
- **Input**: Research query, depth level, source preferences
- **Output**: Comprehensive research report with citations
- **Use Cases**: Market research, technical investigation, competitive analysis

#### **Context Curator**
- **Purpose**: Intelligent codebase analysis with 8-phase workflow
- **Input**: Project directory, analysis prompt, task type
- **Output**: Curated context optimized for AI consumption
- **Features**: Language-agnostic detection, 250K token budget, multi-format output

### 🏗️ **Generation Tools**

#### **Code Map Generator**
- **Purpose**: Semantic codebase mapping for 35+ languages
- **Input**: Target directory, output format, optimization level
- **Output**: Markdown index + Mermaid diagrams
- **Optimization**: 95-97% token reduction, importance-based filtering

#### **Fullstack Starter Kit Generator**
- **Purpose**: Dynamic project template generation
- **Input**: Technology stack, project requirements, architecture preferences
- **Output**: Complete project structure with configuration
- **Features**: 20+ technology combinations, JSON sanitization

### 🎯 **Task Management Tools**

#### **Vibe Task Manager**
- **Purpose**: AI-powered project decomposition and agent orchestration
- **Input**: Project description, complexity level, team size
- **Output**: Hierarchical task breakdown with agent assignments
- **Features**: RDD methodology, multi-agent coordination, real-time tracking

#### **Agent Registry**
- **Purpose**: AI agent registration and task coordination
- **Input**: Agent capabilities, availability, specializations
- **Output**: Agent registration confirmation and task assignments
- **Features**: Capability mapping, load balancing, performance tracking

### 📄 **Document Generation Tools**

#### **PRD Generator**
- **Purpose**: Comprehensive Product Requirements Document creation
- **Input**: Product concept, target audience, feature requirements
- **Output**: Structured PRD with technical specifications
- **Features**: Template-based generation, stakeholder analysis

#### **User Story Generator**
- **Purpose**: Feature development user story creation
- **Input**: Feature description, user personas, acceptance criteria
- **Output**: Formatted user stories with acceptance criteria
- **Features**: Persona-based generation, priority scoring

### ⚡ **Workflow & Execution Tools**

#### **Workflow Runner**
- **Purpose**: Automated execution of predefined tool sequences
- **Input**: Workflow name, execution parameters
- **Output**: Workflow execution results and status
- **Features**: Sequential execution, error handling, rollback support

#### **Job Result Manager**
- **Purpose**: Asynchronous job monitoring and result retrieval
- **Input**: Job ID, result format preferences
- **Output**: Job status, progress, and final results
- **Features**: Real-time updates, result caching, export options

---

## 🚀 **Getting Started**

### **For End Users (Chrome Extension)**
1. Install Chrome extension from the built `dist/` folder
2. Start local MCP server: `npm start`
3. Open extension popup and start using AI tools

### **For Developers (MCP Integration)**
1. Clone repository: `git clone https://github.com/freshtechbro/RepoTools.git`
2. Install dependencies: `npm install`
3. Configure: Update `llm_config.json` and `mcp-config.json`
4. Run: `npm start` for stdio, or `npm run server:ws` for WebSocket

### **For AI Agents (API Access)**
1. Start HTTP server: `npm run server:http`
2. Connect to WebSocket: `ws://localhost:3000`
3. Use REST API: `http://localhost:3000/api/`

---

## 🤝 **Contributing**

RepoTools is built on the solid foundation of Vibe-Coder-MCP server tools. We welcome contributions to both the Chrome extension interface and the underlying MCP server architecture.

### **Development Workflow**
1. Fork repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Run tests: `npm test` (maintain 99.8% success rate)
4. Submit pull request

### **Architecture Guidelines**
- Follow existing tool registry patterns
- Maintain security boundaries
- Add comprehensive tests
- Update documentation

---

## 📄 **License**

MIT License - see LICENSE file for details

## 🔗 **Links**

- **🌐 Official Website**: https://repotools.ai
- **📚 Documentation**: https://docs.repotools.ai
- **🔧 API Reference**: https://api.repotools.ai
- **💬 Community**: https://community.repotools.ai
- **Chrome Extension**: Available in repository
- **MCP Server**: Built on Vibe-Coder-MCP architecture
- **🐛 Support & Issues**: https://github.com/freshtechbro/RepoTools/issues

---

**RepoTools** - Empowering developers with AI-powered tools, accessible everywhere.

*Built on the robust Vibe-Coder-MCP server architecture • Chrome Extension Interface • 14 AI Tools • Enterprise Ready*

🌐 **Visit us at [repotools.ai](https://repotools.ai)** for the latest updates and community resources.

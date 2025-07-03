# Repotools Lightweight Server - CLAUDE.md

## Project Overview

The Repotools Lightweight Server is a high-performance Express.js-based processing layer that serves as the backend for the Repotools Chrome extension. It provides secure file system access, task management, and real-time communication capabilities to bridge the gap between the Chrome extension and the main MCP system.

### Key Responsibilities
- **File System Access**: Secure, sandboxed file operations for the Chrome extension
- **Task Processing**: Asynchronous task execution with progress tracking and WebSocket updates
- **Real-time Communication**: WebSocket-based bidirectional communication with clients
- **API Gateway**: RESTful API endpoints for Chrome extension integration
- **Security Layer**: Authentication, authorization, and input validation

## Architecture Overview

The server follows a modular, service-oriented architecture with clear separation of concerns:

```
src/
├── config/           # Configuration management
├── middleware/       # Express middleware (auth, error handling, rate limiting)
├── routes/          # API route definitions
├── services/        # Core business logic services
└── utils/           # Utility functions and helpers
```

### Core Components

1. **RepotoolsServer**: Main server class that orchestrates all components
2. **TaskManager**: Handles task lifecycle and execution
3. **FileSystemService**: Provides secure file system operations
4. **WebSocketManager**: Manages real-time client connections
5. **Authentication**: API key and JWT-based security

## Build and Development Commands

### Package Scripts
```bash
# Development
npm run dev              # Start development server with hot reload
npm run type-check       # TypeScript type checking without compilation

# Building
npm run build            # Compile TypeScript to JavaScript
npm run clean            # Remove build artifacts

# Production
npm start                # Start production server
npm run start:prod       # Start with production environment

# Testing
npm test                 # Run test suite
npm run test:watch       # Run tests in watch mode
npm run test:coverage    # Run tests with coverage report

# Code Quality
npm run lint             # Run ESLint with auto-fix

# Docker
npm run docker:build     # Build Docker image
npm run docker:run       # Run Docker container
```

### Environment Setup
1. Copy `.env.example` to `.env`
2. Configure required environment variables:
   - `JWT_SECRET`: Secret key for JWT token signing
   - `API_KEY`: API key for Chrome extension authentication
   - `WORKSPACE_ROOT`: Directory for file system operations
   - External service API keys (OpenAI, Anthropic, GitHub)

## API Structure and Endpoints

### Base URL: `http://localhost:3001`

### Core API Routes (`/api/v1`)

#### Task Management (`/api/v1/tasks`)
- **POST /tasks**: Create new task
- **GET /tasks**: List tasks with filtering and pagination
- **GET /tasks/:taskId**: Get specific task details
- **POST /tasks/:taskId/control**: Control task execution (pause/resume/cancel)
- **DELETE /tasks/:taskId**: Cancel and remove task
- **GET /tasks/queue/status**: Get queue status and statistics
- **POST /tasks/bulk/cancel**: Cancel multiple tasks
- **GET /tasks/types**: Get available task types

#### File System (`/api/v1/files`)
- File operations (read, write, delete, copy, move)
- Directory listing and management
- File search and content search
- Archive creation and extraction
- File watching capabilities

#### WebSocket Management (`/api/v1/ws`)
- Connection management
- Client statistics
- Message broadcasting

#### System (`/api/v1/system`)
- Health checks
- System information
- Performance metrics

### Health Endpoint
- **GET /health**: Server health status (no authentication required)

### WebSocket Endpoint
- **WS /ws**: Real-time communication channel

## Middleware and Service Layer Patterns

### Security Middleware
- **Helmet**: Security headers and CSP configuration
- **CORS**: Configured for Chrome extension origins
- **Rate Limiting**: Prevents abuse and DoS attacks
- **API Key Validation**: Required for all `/api` endpoints

### Authentication Patterns
- **API Key**: Primary authentication method for Chrome extension
- **JWT Tokens**: Optional for user-specific operations
- **Permission-based Access**: Role and permission validation

### Error Handling
- Centralized error handling with custom error types
- Structured error responses with proper HTTP status codes
- Context-aware error logging with request details

### Service Layer Architecture
```typescript
// Service dependencies injection pattern
interface ServiceDependencies {
  taskManager: TaskManager;
  fileSystemService: FileSystemService;
  wsManager: WebSocketManager;
}

// Services are injected into routes
setupRoutes(app: Application, services: ServiceDependencies)
```

## Task Management System

### Task Types
1. **code-map-generator**: Generate semantic code maps and dependency analysis
2. **context-curator**: Curate project context for AI assistance
3. **research-manager**: Manage research tasks and findings
4. **custom**: Execute custom processing tasks

### Task Lifecycle
```
pending → running → completed/failed
           ↓
        paused → running
```

### Task Execution Features
- **Concurrent Processing**: Configurable max concurrent tasks
- **Progress Tracking**: Real-time progress updates via WebSocket
- **Retry Logic**: Automatic retry with exponential backoff
- **Timeout Handling**: Configurable task timeouts
- **Cleanup**: Automatic cleanup of old completed tasks

## File System Service

### Security Features
- **Path Validation**: Prevents directory traversal attacks
- **Workspace Sandboxing**: All operations restricted to workspace directory
- **File Extension Filtering**: Configurable allowed file extensions
- **Size Limits**: Configurable maximum file size limits

### Supported Operations
- **CRUD Operations**: Create, read, update, delete files and directories
- **Search**: Content search with regex support
- **Archives**: Create and extract ZIP archives
- **Watching**: Real-time file system monitoring

## WebSocket Communication

### Message Types
- **task_update**: Real-time task progress and completion
- **system_notification**: System-wide notifications
- **ping/pong**: Connection heartbeat
- **subscription**: Event channel management

### Connection Management
- **Client Tracking**: Unique client IDs and metadata
- **Heartbeat**: Automatic dead connection cleanup
- **Broadcast**: Efficient message broadcasting to all clients

## Development Workflow

### Getting Started
1. **Clone and Install**:
   ```bash
   cd lightweight-server
   npm install
   ```

2. **Environment Setup**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Development Server**:
   ```bash
   npm run dev
   ```

### Common Development Tasks

#### Adding New Task Types
1. Create executor class implementing `TaskExecutor` interface
2. Register executor in `TaskManager.setupDefaultExecutors()`
3. Add validation schema in `routes/tasks.ts`
4. Update task types documentation

#### Adding New API Endpoints
1. Create route handler in appropriate route file
2. Add validation schemas using Joi
3. Implement service layer logic
4. Add proper error handling and logging

#### Extending File System Operations
1. Add method to `FileSystemService` class
2. Implement proper validation and security checks
3. Add corresponding API endpoint
4. Update file operation logging

## Integration Points

### Chrome Extension Integration
- **Authentication**: API key-based authentication
- **Task Submission**: RESTful API for task creation and management
- **Real-time Updates**: WebSocket connection for progress tracking
- **File Access**: Secure file system operations

### MCP System Integration
- **Processing Layer**: Handles computationally intensive tasks
- **Data Exchange**: Structured data formats for seamless integration
- **Service Discovery**: Health checks and capability reporting

## Configuration Management

### Environment Variables
```bash
# Server
NODE_ENV=development|production|test
PORT=3001
HOST=localhost

# Security
JWT_SECRET=your-jwt-secret
API_KEY=your-api-key

# File System
WORKSPACE_ROOT=/path/to/workspace
MAX_FILE_SIZE=100MB
ALLOWED_EXTENSIONS=.js,.ts,.py,...

# External Services
OPENAI_API_KEY=your-openai-key
ANTHROPIC_API_KEY=your-anthropic-key
GITHUB_TOKEN=your-github-token

# Task Management
MAX_CONCURRENT_TASKS=5
TASK_TIMEOUT=300000
CLEANUP_INTERVAL=3600000

# WebSocket
WS_HEARTBEAT_INTERVAL=30000

# Logging
LOG_LEVEL=info|debug|warn|error
LOG_FILE=./logs/repotools.log
```

### TypeScript Configuration
- **ES2022 Target**: Modern JavaScript features
- **ESNext Modules**: ES module system
- **Path Aliases**: Organized import paths (@/, @services/, etc.)
- **Strict Mode**: Full TypeScript strictness enabled

## Testing and Quality Assurance

### Testing Setup
- **Jest**: Testing framework with TypeScript support
- **Supertest**: HTTP endpoint testing
- **Coverage**: Code coverage reporting
- **Watch Mode**: Development-friendly test watching

### Code Quality
- **ESLint**: TypeScript-aware linting
- **Prettier**: Code formatting (configured via ESLint)
- **TypeScript**: Strict type checking

## Performance and Monitoring

### Logging System
- **Structured Logging**: JSON-formatted logs
- **Multiple Outputs**: Console and file logging
- **Log Levels**: Error, warn, info, debug
- **Context Logging**: Request correlation and task tracking

### Performance Features
- **Compression**: Gzip compression for HTTP responses
- **Connection Pooling**: Efficient resource management
- **Rate Limiting**: Configurable rate limits per endpoint
- **Graceful Shutdown**: Proper cleanup on server shutdown

## Security Considerations

### Input Validation
- **Joi Schemas**: Comprehensive input validation
- **Path Sanitization**: Prevents directory traversal
- **File Type Validation**: Restricted file extensions
- **Size Limits**: Prevents resource exhaustion

### Security Headers
- **CSP**: Content Security Policy
- **CORS**: Proper origin validation
- **Helmet**: Security headers middleware

## Common Issues and Solutions

### File System Access Issues
- **Permission Errors**: Check workspace directory permissions
- **Path Traversal**: Ensure proper path validation
- **Size Limits**: Verify file size configurations

### WebSocket Connection Issues
- **CORS**: Verify origin configuration
- **Heartbeat**: Check heartbeat interval settings
- **Client Cleanup**: Monitor connection cleanup logs

### Task Execution Problems
- **Timeout Issues**: Adjust task timeout settings
- **Concurrency**: Review max concurrent task limits
- **Memory Usage**: Monitor task memory consumption

## Deployment

### Production Considerations
- **Environment Variables**: Set production-specific values
- **Process Management**: Use PM2 or similar process manager
- **Reverse Proxy**: nginx or Apache for SSL termination
- **Log Rotation**: Configure log rotation to prevent disk space issues

### Docker Deployment
```bash
# Build image
npm run docker:build

# Run container
npm run docker:run
```

### Health Monitoring
- **Health Endpoint**: `/health` for load balancer checks
- **Metrics**: Performance and usage metrics
- **Alerting**: Set up alerts for error rates and performance degradation

## Contributing

### Development Guidelines
- Follow TypeScript best practices
- Maintain proper error handling
- Add comprehensive logging
- Write tests for new features
- Update documentation

### Code Style
- Use ESLint configuration
- Follow existing naming conventions
- Maintain service layer separation
- Keep middleware focused and reusable
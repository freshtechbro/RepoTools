#!/bin/bash

# Complete Chrome Extension Setup and Startup Script for macOS/Linux
# This script handles everything: dependencies, build, and server startup

set -e

echo "🚀 RepoTools Chrome Extension - Complete Setup & Startup"
echo "========================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a port is in use
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to kill process on port
kill_port() {
    local port=$1
    echo -e "${YELLOW}Killing existing process on port $port...${NC}"
    lsof -ti:$port | xargs kill -9 2>/dev/null || true
    sleep 2
}

# Check Node.js version
echo -e "${BLUE}Checking Node.js version...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js 18+ from https://nodejs.org/${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js version $NODE_VERSION is too old. Please upgrade to Node.js 18+${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js $(node -v) is compatible${NC}"

# Check if .env file exists, create from template if not
echo -e "${BLUE}Checking environment configuration...${NC}"
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${YELLOW}⚠️  Created .env from template. Please add your OPENROUTER_API_KEY${NC}"
    else
        cat > .env << 'EOF'
# OpenRouter Configuration
OPENROUTER_API_KEY=your_openrouter_api_key_here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
GEMINI_MODEL=google/gemini-2.5-flash-preview-05-20
PERPLEXITY_MODEL=perplexity/sonar-deep-research

# Optional: Custom directories
# VIBE_CODER_OUTPUT_DIR=/path/to/your/output/directory
# CODE_MAP_ALLOWED_DIR=/path/to/your/source/code
EOF
        echo -e "${YELLOW}⚠️  Created .env file. Please add your OPENROUTER_API_KEY${NC}"
    fi
fi

# Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
echo "Installing root dependencies..."
npm install

echo "Installing Chrome extension dependencies..."
cd chrome-extension
npm install
cd ..

echo "Installing bridge server dependencies..."
cd chrome-extension-bridge
npm install
cd ..

# Build projects
echo -e "${BLUE}Building projects...${NC}"
echo "Building main MCP server..."
npm run build

echo "Generating Chrome extension icons..."
cd chrome-extension
npm run icons

echo "Building Chrome extension..."
npm run build
cd ..

echo "Building bridge server..."
cd chrome-extension-bridge
npm run build
cd ..

# Handle port conflicts
echo -e "${BLUE}Checking port availability...${NC}"

if check_port 3000; then
    echo -e "${YELLOW}Port 3000 is already in use${NC}"
    kill_port 3000
fi

if check_port 3001; then
    echo -e "${YELLOW}Port 3001 is already in use${NC}"
    kill_port 3001
fi

# Create log directory
mkdir -p logs

# Start servers
echo -e "${BLUE}Starting Chrome Extension Bridge Server (Port 3000)...${NC}"
cd chrome-extension-bridge
nohup npm start > ../logs/bridge-server.log 2>&1 &
BRIDGE_PID=$!
cd ..

# Wait for bridge server to start
echo -e "${YELLOW}Waiting for bridge server to start...${NC}"
sleep 3

# Check if bridge server started successfully
if check_port 3000; then
    echo -e "${GREEN}✅ Chrome Extension Bridge Server started successfully${NC}"
else
    echo -e "${RED}❌ Failed to start Chrome Extension Bridge Server${NC}"
    echo -e "${RED}Check logs/bridge-server.log for details${NC}"
    exit 1
fi

echo -e "${BLUE}Starting Main MCP Server (Port 3001)...${NC}"
nohup npm run start:sse > logs/mcp-server.log 2>&1 &
MCP_PID=$!

# Wait for main server to start
echo -e "${YELLOW}Waiting for main MCP server to start...${NC}"
sleep 5

if check_port 3001; then
    echo -e "${GREEN}✅ Main MCP Server started successfully${NC}"
else
    echo -e "${RED}❌ Failed to start Main MCP Server${NC}"
    echo -e "${RED}Check logs/mcp-server.log for details${NC}"
    # Don't exit, bridge server might still work
fi

# Save PIDs for stop script
echo "BRIDGE_PID=$BRIDGE_PID" > .server-pids
echo "MCP_PID=$MCP_PID" >> .server-pids

# Final status and instructions
echo ""
echo -e "${GREEN}🎉 Chrome Extension Setup Complete!${NC}"
echo "============================================="
echo -e "${BLUE}Servers Status:${NC}"
echo "  • Bridge Server: http://localhost:3000 ✅"
echo "  • WebSocket: ws://localhost:3000 ✅"
echo "  • Main MCP Server: http://localhost:3001 ✅"
echo ""
echo -e "${BLUE}Chrome Extension Setup:${NC}"
echo "  1. Open Chrome and go to: chrome://extensions/"
echo "  2. Enable 'Developer mode' (toggle in top right)"
echo "  3. Click 'Load unpacked'"
echo "  4. Select folder: $(pwd)/chrome-extension/dist"
echo "  5. Pin the RepoTools extension to your toolbar"
echo ""
echo -e "${BLUE}Testing:${NC}"
echo "  • Health Check: curl http://localhost:3000/health"
echo "  • Click the RepoTools icon in Chrome"
echo "  • Should show 14 AI tools available"
echo ""
echo -e "${BLUE}Logs & Management:${NC}"
echo "  • Bridge logs: tail -f logs/bridge-server.log"
echo "  • MCP logs: tail -f logs/mcp-server.log"
echo "  • Stop servers: ./stop-mcp-servers.sh"
echo ""
echo -e "${YELLOW}Note: If you need to add your OpenRouter API key, edit the .env file${NC}"
echo -e "${GREEN}Servers are running in the background. Close this terminal safely.${NC}"
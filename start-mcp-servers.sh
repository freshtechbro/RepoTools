#!/bin/bash

# Start MCP Servers for Chrome Extension
# This script starts both the main MCP server and the Chrome Extension Bridge

set -e

echo "🚀 Starting Repotools MCP Servers for Chrome Extension"
echo "=================================================="

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

# Check and handle port conflicts
echo -e "${BLUE}Checking port availability...${NC}"

if check_port 3000; then
    echo -e "${YELLOW}Port 3000 is already in use${NC}"
    read -p "Kill existing process on port 3000? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        kill_port 3000
    else
        echo -e "${RED}Cannot start bridge server on port 3000${NC}"
        exit 1
    fi
fi

if check_port 3001; then
    echo -e "${YELLOW}Port 3001 is already in use${NC}"
    read -p "Kill existing process on port 3001? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        kill_port 3001
    else
        echo -e "${YELLOW}Assuming main MCP server is already running on port 3001${NC}"
    fi
fi

# Create log directory
mkdir -p logs

echo -e "${BLUE}Building Chrome Extension Bridge...${NC}"
cd chrome-extension-bridge
npm run build
cd ..

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
    echo -e "${GREEN}   📍 HTTP: http://localhost:3000${NC}"
    echo -e "${GREEN}   🔌 WebSocket: ws://localhost:3000${NC}"
    echo -e "${GREEN}   🏥 Health: http://localhost:3000/health${NC}"
else
    echo -e "${RED}❌ Failed to start Chrome Extension Bridge Server${NC}"
    echo -e "${RED}Check logs/bridge-server.log for details${NC}"
    exit 1
fi

# Check if main MCP server is needed
if ! check_port 3001; then
    echo -e "${BLUE}Starting Main MCP Server (Port 3001)...${NC}"
    nohup npm run start:sse > logs/mcp-server.log 2>&1 &
    MCP_PID=$!
    
    # Wait for main server to start
    echo -e "${YELLOW}Waiting for main MCP server to start...${NC}"
    sleep 5
    
    if check_port 3001; then
        echo -e "${GREEN}✅ Main MCP Server started successfully${NC}"
        echo -e "${GREEN}   📍 HTTP: http://localhost:3001${NC}"
        echo -e "${GREEN}   📡 SSE: http://localhost:3001/sse${NC}"
    else
        echo -e "${RED}❌ Failed to start Main MCP Server${NC}"
        echo -e "${RED}Check logs/mcp-server.log for details${NC}"
    fi
else
    echo -e "${GREEN}✅ Main MCP Server already running on port 3001${NC}"
fi

echo ""
echo -e "${GREEN}🎉 MCP Servers are ready for Chrome Extension!${NC}"
echo "=================================================="
echo -e "${BLUE}Chrome Extension Configuration:${NC}"
echo "  • Server URL: ws://localhost:3000"
echo "  • Auto-connection: Enabled"
echo "  • Available Tools: 14 AI development tools"
echo ""
echo -e "${BLUE}Testing:${NC}"
echo "  • Health Check: curl http://localhost:3000/health"
echo "  • WebSocket Test: cd chrome-extension-bridge && node test-websocket.js"
echo "  • Load Chrome Extension: chrome://extensions/ → Load unpacked → chrome-extension/dist"
echo ""
echo -e "${BLUE}Logs:${NC}"
echo "  • Bridge Server: tail -f logs/bridge-server.log"
echo "  • Main MCP Server: tail -f logs/mcp-server.log"
echo ""
echo -e "${BLUE}Stop Servers:${NC}"
echo "  • Kill Bridge: kill $BRIDGE_PID"
if [ ! -z "$MCP_PID" ]; then
    echo "  • Kill MCP: kill $MCP_PID"
fi
echo "  • Or run: ./stop-mcp-servers.sh"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop monitoring, servers will continue running in background${NC}"

# Save PIDs for stop script
echo "BRIDGE_PID=$BRIDGE_PID" > .server-pids
if [ ! -z "$MCP_PID" ]; then
    echo "MCP_PID=$MCP_PID" >> .server-pids
fi

# Monitor logs (optional)
echo -e "${BLUE}Monitoring bridge server logs (Ctrl+C to stop monitoring):${NC}"
tail -f logs/bridge-server.log

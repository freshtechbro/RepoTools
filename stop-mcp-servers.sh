#!/bin/bash

# Stop MCP Servers for Chrome Extension

set -e

echo "🛑 Stopping Repotools MCP Servers"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to kill process on port
kill_port() {
    local port=$1
    local name=$2
    echo -e "${YELLOW}Stopping $name on port $port...${NC}"
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
        sleep 1
        
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo -e "${RED}❌ Failed to stop $name on port $port${NC}"
        else
            echo -e "${GREEN}✅ Stopped $name${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  $name not running on port $port${NC}"
    fi
}

# Stop servers using saved PIDs if available
if [ -f .server-pids ]; then
    echo -e "${BLUE}Using saved process IDs...${NC}"
    source .server-pids
    
    if [ ! -z "$BRIDGE_PID" ]; then
        echo -e "${YELLOW}Stopping Bridge Server (PID: $BRIDGE_PID)...${NC}"
        kill $BRIDGE_PID 2>/dev/null || true
    fi
    
    if [ ! -z "$MCP_PID" ]; then
        echo -e "${YELLOW}Stopping MCP Server (PID: $MCP_PID)...${NC}"
        kill $MCP_PID 2>/dev/null || true
    fi
    
    sleep 2
    rm -f .server-pids
fi

# Kill by port as backup
kill_port 3000 "Chrome Extension Bridge Server"
kill_port 3001 "Main MCP Server"

# Kill any remaining node processes that might be related
echo -e "${YELLOW}Cleaning up any remaining processes...${NC}"
pkill -f "chrome-extension-bridge" 2>/dev/null || true
pkill -f "mcp.*server" 2>/dev/null || true

echo ""
echo -e "${GREEN}🎉 All MCP servers stopped successfully!${NC}"
echo ""
echo -e "${BLUE}To restart servers:${NC}"
echo "  ./start-mcp-servers.sh"
echo ""
echo -e "${BLUE}To check if ports are free:${NC}"
echo "  lsof -i :3000"
echo "  lsof -i :3001"

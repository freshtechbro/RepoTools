#!/bin/bash
set -e

echo "Setting up Vibe Coder MCP development environment..."

# Update package lists
sudo apt-get update

# Install Node.js 18+ if not present or version is too old
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
elif [ "$(node -v | cut -d'v' -f2 | cut -d'.' -f1)" -lt 18 ]; then
    echo "Upgrading Node.js to version 18..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Clean npm cache if needed
echo "Cleaning npm cache..."
npm cache clean --force

# Install dependencies
echo "Installing project dependencies..."
npm ci

# Create required directories
echo "Creating required output directories..."
mkdir -p VibeCoderOutput/{research-manager,rules-generator,prd-generator,user-stories-generator,task-list-generator,fullstack-starter-kit-generator,workflow-runner,code-map-generator,vibe-task-manager,context-curator,job-result-retriever,agent-registry,agent-tasks,agent-response,generated_task_lists}

# Create test directories in user space (not system directories)
echo "Creating test directories for security tests..."
mkdir -p "$HOME/test-workspace/allowed"
mkdir -p "$HOME/test-workspace/output"
echo "test content" > "$HOME/test-workspace/allowed/test-file.txt"
echo "console.log('test');" > "$HOME/test-workspace/allowed/safe-file.js"
echo "test data" > "$HOME/test-workspace/allowed/test.txt"

# Create .env file from example if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    # Set up proper test environment variables with user space directories
    cat >> .env << EOF
OPENROUTER_API_KEY=test-key-for-testing
NODE_ENV=test
LOG_LEVEL=error
VIBE_TASK_MANAGER_READ_DIR=$HOME/test-workspace/allowed
VIBE_CODER_OUTPUT_DIR=$HOME/test-workspace/output
CODE_MAP_ALLOWED_DIR=$HOME/test-workspace/allowed
VIBE_TASK_MANAGER_SECURITY_MODE=permissive
E2E_MODE=mock
EOF
fi

# Build the project
echo "Building TypeScript project..."
npm run build

# Copy assets
echo "Copying assets..."
npm run copy-assets

echo "Setup completed successfully!"
echo "Node.js version: $(node -v)"
echo "Project built and ready for testing."
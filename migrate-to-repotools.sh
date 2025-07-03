#!/bin/bash

# Migration Script: Vibe-Coder-MCP Chrome Extension -> RepoTools Repository
# This script migrates all Chrome extension work to the RepoTools repo

set -e

echo "🚀 RepoTools Migration Script"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPOTOOLS_REPO="https://github.com/freshtechbro/RepoTools.git"
MIGRATION_DIR="/tmp/repotools-migration-$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="/tmp/repotools-backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${BLUE}Migration Configuration:${NC}"
echo "Source: $(pwd)"
echo "Target Repo: $REPOTOOLS_REPO"
echo "Migration Dir: $MIGRATION_DIR"
echo "Backup Dir: $BACKUP_DIR"
echo ""

# Confirm migration
read -p "This will override the RepoTools repository with your Chrome extension work. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Migration cancelled."
    exit 1
fi

# Step 1: Create backup of RepoTools repo
echo -e "${BLUE}Step 1: Backing up existing RepoTools repository...${NC}"
git clone $REPOTOOLS_REPO $BACKUP_DIR
echo -e "${GREEN}✅ RepoTools repo backed up to: $BACKUP_DIR${NC}"

# Step 2: Clone fresh RepoTools repo
echo -e "${BLUE}Step 2: Cloning fresh RepoTools repository...${NC}"
git clone $REPOTOOLS_REPO $MIGRATION_DIR
cd $MIGRATION_DIR

# Step 3: Save original README
echo -e "${BLUE}Step 3: Preserving RepoTools README...${NC}"
if [ -f "README.md" ]; then
    cp README.md /tmp/repotools-readme-original.md
    echo -e "${GREEN}✅ Original README saved${NC}"
else
    echo -e "${YELLOW}⚠️  No README.md found in RepoTools repo${NC}"
fi

# Step 4: Clear repository (except .git)
echo -e "${BLUE}Step 4: Clearing repository content...${NC}"
find . -not -path "./.git*" -not -name ".gitignore" -delete
echo -e "${GREEN}✅ Repository cleared${NC}"

# Step 5: Copy all content from source
echo -e "${BLUE}Step 5: Copying Chrome extension work...${NC}"
rsync -av --exclude='.git' --exclude='node_modules' --exclude='dist' --exclude='build' --exclude='logs' --exclude='.server-pids' /Users/bishopdotun/Documents/Repotools/Vibe-Coder-MCP/ .

# Step 6: Restore README if it existed
if [ -f "/tmp/repotools-readme-original.md" ]; then
    echo -e "${BLUE}Step 6: Restoring original RepoTools README...${NC}"
    cp /tmp/repotools-readme-original.md README.md
    echo -e "${GREEN}✅ Original README restored${NC}"
fi

# Step 7: Update branding in key files
echo -e "${BLUE}Step 7: Updating branding to RepoTools...${NC}"

# Update package.json files
if [ -f "package.json" ]; then
    sed -i.bak 's/vibe-coder-mcp/repotools/g' package.json
    sed -i.bak 's/Vibe Coder MCP/RepoTools/g' package.json
    rm package.json.bak
fi

if [ -f "chrome-extension/package.json" ]; then
    sed -i.bak 's/vibe-coder-mcp/repotools/g' chrome-extension/package.json
    sed -i.bak 's/Vibe Coder MCP/RepoTools/g' chrome-extension/package.json
    rm chrome-extension/package.json.bak
fi

if [ -f "chrome-extension-bridge/package.json" ]; then
    sed -i.bak 's/vibe-coder-mcp/repotools/g' chrome-extension-bridge/package.json
    sed -i.bak 's/Vibe Coder MCP/RepoTools/g' chrome-extension-bridge/package.json
    rm chrome-extension-bridge/package.json.bak
fi

# Update manifest.json
if [ -f "chrome-extension/manifest.json" ]; then
    sed -i.bak 's/Vibe Coder/RepoTools/g' chrome-extension/manifest.json
    rm chrome-extension/manifest.json.bak
fi

# Update CLAUDE.md files to reference RepoTools
find . -name "CLAUDE.md" -exec sed -i.bak 's/Vibe Coder MCP/RepoTools/g' {} \;
find . -name "CLAUDE.md.bak" -delete

echo -e "${GREEN}✅ Branding updated to RepoTools${NC}"

# Step 8: Create migration-specific .gitignore
echo -e "${BLUE}Step 8: Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.tsbuildinfo

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log
.server-pids

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
.pnp/
.pnp.js

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
tmp/
temp/
*.tmp
*.temp
EOF

echo -e "${GREEN}✅ .gitignore created${NC}"

# Step 9: Stage all changes
echo -e "${BLUE}Step 9: Staging changes for commit...${NC}"
git add .
echo -e "${GREEN}✅ All changes staged${NC}"

# Step 10: Create migration commit
echo -e "${BLUE}Step 10: Creating migration commit...${NC}"
git commit -m "feat: Complete migration from Vibe-Coder-MCP to RepoTools

- Migrate Chrome extension with 14 AI development tools
- Add WebSocket bridge server for MCP communication  
- Include lightweight server for processing layer
- Add comprehensive documentation and setup scripts
- Update branding from Vibe Coder MCP to RepoTools
- Preserve original RepoTools README

Components migrated:
- Chrome Extension with React + TypeScript + TailwindCSS
- WebSocket Bridge Server (Express.js)
- Lightweight Processing Server
- Automated setup and startup scripts
- Comprehensive CLAUDE.md documentation files

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo -e "${GREEN}✅ Migration commit created${NC}"

# Final instructions
echo ""
echo -e "${GREEN}🎉 Migration completed successfully!${NC}"
echo "============================================="
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review the changes in: $MIGRATION_DIR"
echo "2. Test the Chrome extension setup:"
echo "   cd $MIGRATION_DIR"
echo "   ./setup-and-start.sh"
echo "3. Push to RepoTools repository:"
echo "   git push origin main"
echo ""
echo -e "${BLUE}Backup locations:${NC}"
echo "• Original RepoTools: $BACKUP_DIR"
echo "• Original README: /tmp/repotools-readme-original.md"
echo ""
echo -e "${YELLOW}⚠️  Remember to update any external references from Vibe-Coder-MCP to RepoTools${NC}"

# Ask if user wants to push immediately
echo ""
read -p "Push changes to RepoTools repository now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Pushing to RepoTools repository...${NC}"
    git push origin main
    echo -e "${GREEN}✅ Changes pushed successfully!${NC}"
    echo ""
    echo "🔗 View your updated repository at: https://github.com/freshtechbro/RepoTools"
else
    echo -e "${YELLOW}Changes staged but not pushed. You can push later with:${NC}"
    echo "cd $MIGRATION_DIR && git push origin main"
fi

echo ""
echo -e "${GREEN}Migration directory: $MIGRATION_DIR${NC}"
echo -e "${GREEN}You can now work from this directory as your new RepoTools repository!${NC}"
@echo off
setlocal enabledelayedexpansion

REM Complete Chrome Extension Setup and Startup Script for Windows
REM This script handles everything: dependencies, build, and server startup

echo 🚀 RepoTools Chrome Extension - Complete Setup ^& Startup
echo ========================================================

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js not found. Please install Node.js 18+ from https://nodejs.org/
    pause
    exit /b 1
)

REM Get Node.js version
for /f "tokens=1 delims=v" %%i in ('node --version') do set NODE_VERSION=%%i
for /f "tokens=1 delims=." %%i in ("%NODE_VERSION%") do set MAJOR_VERSION=%%i
if %MAJOR_VERSION% LSS 18 (
    echo ❌ Node.js version is too old. Please upgrade to Node.js 18+
    pause
    exit /b 1
)
echo ✅ Node.js is compatible

REM Check if .env file exists, create from template if not
echo Checking environment configuration...
if not exist ".env" (
    if exist ".env.example" (
        copy ".env.example" ".env" >nul
        echo ⚠️  Created .env from template. Please add your OPENROUTER_API_KEY
    ) else (
        echo # OpenRouter Configuration > .env
        echo OPENROUTER_API_KEY=your_openrouter_api_key_here >> .env
        echo OPENROUTER_BASE_URL=https://openrouter.ai/api/v1 >> .env
        echo GEMINI_MODEL=google/gemini-2.5-flash-preview-05-20 >> .env
        echo PERPLEXITY_MODEL=perplexity/sonar-deep-research >> .env
        echo. >> .env
        echo # Optional: Custom directories >> .env
        echo # VIBE_CODER_OUTPUT_DIR=/path/to/your/output/directory >> .env
        echo # CODE_MAP_ALLOWED_DIR=/path/to/your/source/code >> .env
        echo ⚠️  Created .env file. Please add your OPENROUTER_API_KEY
    )
)

REM Install dependencies
echo Installing dependencies...
echo Installing root dependencies...
call npm install
if errorlevel 1 (
    echo ❌ Failed to install root dependencies
    pause
    exit /b 1
)

echo Installing Chrome extension dependencies...
cd chrome-extension
call npm install
if errorlevel 1 (
    echo ❌ Failed to install Chrome extension dependencies
    pause
    exit /b 1
)
cd ..

echo Installing bridge server dependencies...
cd chrome-extension-bridge
call npm install
if errorlevel 1 (
    echo ❌ Failed to install bridge server dependencies
    pause
    exit /b 1
)
cd ..

REM Build projects
echo Building projects...
echo Building main MCP server...
call npm run build
if errorlevel 1 (
    echo ❌ Failed to build main MCP server
    pause
    exit /b 1
)

echo Generating Chrome extension icons...
cd chrome-extension
call npm run icons
if errorlevel 1 (
    echo ⚠️  Icon generation failed, continuing...
)

echo Building Chrome extension...
call npm run build
if errorlevel 1 (
    echo ❌ Failed to build Chrome extension
    pause
    exit /b 1
)
cd ..

echo Building bridge server...
cd chrome-extension-bridge
call npm run build
if errorlevel 1 (
    echo ❌ Failed to build bridge server
    pause
    exit /b 1
)
cd ..

REM Kill existing processes on ports 3000 and 3001
echo Checking for existing processes...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
    taskkill /PID %%a /F >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001') do (
    taskkill /PID %%a /F >nul 2>&1
)

REM Create log directory
if not exist "logs" mkdir logs

REM Start servers
echo Starting Chrome Extension Bridge Server (Port 3000)...
cd chrome-extension-bridge
start /b cmd /c "npm start > ../logs/bridge-server.log 2>&1"
cd ..

REM Wait for bridge server to start
echo Waiting for bridge server to start...
timeout /t 5 /nobreak >nul

REM Check if bridge server started (simplified check)
netstat -ano | findstr :3000 >nul
if errorlevel 1 (
    echo ❌ Failed to start Chrome Extension Bridge Server
    echo Check logs/bridge-server.log for details
    pause
    exit /b 1
) else (
    echo ✅ Chrome Extension Bridge Server started successfully
)

echo Starting Main MCP Server (Port 3001)...
start /b cmd /c "npm run start:sse > logs/mcp-server.log 2>&1"

REM Wait for main server to start
echo Waiting for main MCP server to start...
timeout /t 8 /nobreak >nul

REM Check if main server started
netstat -ano | findstr :3001 >nul
if errorlevel 1 (
    echo ❌ Failed to start Main MCP Server
    echo Check logs/mcp-server.log for details
) else (
    echo ✅ Main MCP Server started successfully
)

REM Final status and instructions
echo.
echo 🎉 Chrome Extension Setup Complete!
echo =============================================
echo Servers Status:
echo   • Bridge Server: http://localhost:3000 ✅
echo   • WebSocket: ws://localhost:3000 ✅
echo   • Main MCP Server: http://localhost:3001 ✅
echo.
echo Chrome Extension Setup:
echo   1. Open Chrome and go to: chrome://extensions/
echo   2. Enable 'Developer mode' (toggle in top right)
echo   3. Click 'Load unpacked'
echo   4. Select folder: %CD%\chrome-extension\dist
echo   5. Pin the RepoTools extension to your toolbar
echo.
echo Testing:
echo   • Health Check: curl http://localhost:3000/health
echo   • Click the RepoTools icon in Chrome
echo   • Should show 14 AI tools available
echo.
echo Logs ^& Management:
echo   • Bridge logs: type logs\bridge-server.log
echo   • MCP logs: type logs\mcp-server.log
echo   • Stop servers: Use Task Manager or restart script
echo.
echo ⚠️  Note: If you need to add your OpenRouter API key, edit the .env file
echo ✅ Servers are running in the background. You can close this window.
echo.
pause
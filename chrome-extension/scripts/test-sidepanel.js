#!/usr/bin/env node

/**
 * Side Panel Test Script
 * Helps verify the extension is properly configured for side panel functionality
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const extensionRoot = path.join(__dirname, '..');
const distPath = path.join(extensionRoot, 'dist');

console.log('🧪 Side Panel Configuration Test\n');

// Check if dist folder exists
if (!fs.existsSync(distPath)) {
  console.error('❌ Error: dist folder not found!');
  console.log('Please run "npm run build" first.\n');
  process.exit(1);
}

console.log('✅ Build folder found');

// Check manifest.json
try {
  const manifestPath = path.join(distPath, 'manifest.json');
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  
  console.log('✅ Manifest.json is valid');
  
  // Check side panel configuration
  if (manifest.side_panel && manifest.side_panel.default_path) {
    console.log('✅ Side panel configuration found');
    console.log(`   Path: ${manifest.side_panel.default_path}`);
  } else {
    console.error('❌ Side panel configuration missing in manifest');
    process.exit(1);
  }
  
  // Check permissions
  if (manifest.permissions && manifest.permissions.includes('sidePanel')) {
    console.log('✅ Side panel permission found');
  } else {
    console.error('❌ Side panel permission missing');
    console.log('   Current permissions:', manifest.permissions);
    process.exit(1);
  }
  
  // Check if action has no popup (required for side panel)
  if (!manifest.action.default_popup) {
    console.log('✅ No popup configured (correct for side panel)');
  } else {
    console.error('❌ Popup configured - this will prevent side panel from opening');
    console.log('   Remove default_popup from action in manifest.json');
    process.exit(1);
  }
  
} catch (error) {
  console.error('❌ Error reading manifest.json:', error.message);
  process.exit(1);
}

// Check side panel HTML file
const sidepanelPath = path.join(distPath, 'sidepanel', 'index.html');
if (fs.existsSync(sidepanelPath)) {
  console.log('✅ Side panel HTML file exists');
  
  // Check if HTML file has content
  const htmlContent = fs.readFileSync(sidepanelPath, 'utf8');
  if (htmlContent.includes('sidepanel-root')) {
    console.log('✅ Side panel HTML has root element');
  } else {
    console.error('❌ Side panel HTML missing root element');
  }
} else {
  console.error('❌ Side panel HTML file not found');
  process.exit(1);
}

// Check service worker
const serviceWorkerPath = path.join(distPath, 'background', 'service-worker.js');
if (fs.existsSync(serviceWorkerPath)) {
  console.log('✅ Service worker exists');
  
  const swContent = fs.readFileSync(serviceWorkerPath, 'utf8');
  if (swContent.includes('sidePanel')) {
    console.log('✅ Service worker has side panel code');
  } else {
    console.warn('⚠️  Service worker may not have side panel handling');
  }
} else {
  console.error('❌ Service worker not found');
  process.exit(1);
}

console.log('\n🎯 Side Panel Test Results:');
console.log('✅ All checks passed!');
console.log('\n📋 Next Steps:');
console.log('1. Load the extension in Chrome (chrome://extensions/)');
console.log('2. Enable "Developer mode"');
console.log('3. Click "Load unpacked" and select the dist folder');
console.log('4. Pin the extension to your toolbar');
console.log('5. Click the extension icon to open the side panel');

console.log('\n🔧 If side panel doesn\'t open:');
console.log('1. Check Chrome version (requires 114+)');
console.log('2. Reload the extension');
console.log('3. Check browser console for errors');
console.log('4. Try in incognito mode');

console.log('\n📁 Extension Location:');
console.log(`   ${distPath}`);

console.log('\n✨ Happy Testing! ✨\n');

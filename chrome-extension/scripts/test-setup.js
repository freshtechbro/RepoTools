#!/usr/bin/env node

/**
 * Test Setup Script for Chrome Extension
 * Helps prepare and validate the extension for testing
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const extensionRoot = path.join(__dirname, '..');
const distPath = path.join(extensionRoot, 'dist');

console.log('🧪 Chrome Extension Test Setup\n');

// Check if dist folder exists
if (!fs.existsSync(distPath)) {
  console.error('❌ Error: dist folder not found!');
  console.log('Please run "npm run build" first to build the extension.\n');
  process.exit(1);
}

console.log('✅ Build folder found');

// Validate required files
const requiredFiles = [
  'manifest.json',
  'popup/index.html',
  'options/index.html',
  'sidepanel/index.html',
  'background/service-worker.js'
];

const missingFiles = [];
requiredFiles.forEach(file => {
  const filePath = path.join(distPath, file);
  if (!fs.existsSync(filePath)) {
    missingFiles.push(file);
  }
});

if (missingFiles.length > 0) {
  console.error('❌ Missing required files:');
  missingFiles.forEach(file => console.log(`   - ${file}`));
  console.log('\nPlease rebuild the extension with "npm run build"\n');
  process.exit(1);
}

console.log('✅ All required files present');

// Check manifest.json
try {
  const manifestPath = path.join(distPath, 'manifest.json');
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  
  console.log('✅ Manifest.json is valid');
  console.log(`   Name: ${manifest.name}`);
  console.log(`   Version: ${manifest.version}`);
  console.log(`   Manifest Version: ${manifest.manifest_version}`);
} catch (error) {
  console.error('❌ Error reading manifest.json:', error.message);
  process.exit(1);
}

// Check assets
const assetsPath = path.join(distPath, 'assets');
if (fs.existsSync(assetsPath)) {
  const assets = fs.readdirSync(assetsPath);
  console.log(`✅ Assets folder contains ${assets.length} files`);
} else {
  console.warn('⚠️  Assets folder not found');
}

// Display testing instructions
console.log('\n📋 Ready for Testing!');
console.log('\nNext steps:');
console.log('1. Open Chrome and go to chrome://extensions/');
console.log('2. Enable "Developer mode" toggle');
console.log('3. Click "Load unpacked" and select the dist folder:');
console.log(`   ${distPath}`);
console.log('4. Follow the testing guide in TESTING_GUIDE.md');

console.log('\n🔧 Quick Commands:');
console.log('   npm run build     - Rebuild extension');
console.log('   npm run dev       - Watch mode for development');
console.log('   npm run clean     - Clean build files');

console.log('\n📁 Extension Location:');
console.log(`   ${distPath}`);

console.log('\n🌐 Testing URLs:');
console.log('   chrome://extensions/           - Load extension');
console.log('   chrome://extensions-internals/ - Debug extension');

// Create a simple test file for file attachment testing
const testFilePath = path.join(extensionRoot, 'test-file.txt');
if (!fs.existsSync(testFilePath)) {
  fs.writeFileSync(testFilePath, 'This is a test file for testing file attachment functionality in the Chrome extension.\n\nYou can use this file to test the file upload feature in the popup interface.');
  console.log('\n📄 Created test-file.txt for file attachment testing');
}

console.log('\n🎯 Focus Areas for Testing:');
console.log('   • Tools dropdown with all 14 AI tools');
console.log('   • File attachment with paperclip icon');
console.log('   • Input/output interface');
console.log('   • Settings page with 4 tabs');
console.log('   • Tool-specific configurations');
console.log('   • Glass design aesthetic');

console.log('\n✨ Happy Testing! ✨\n');

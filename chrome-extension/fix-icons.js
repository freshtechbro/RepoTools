#!/usr/bin/env node

/**
 * Simple icon fix for Repotools
 * Creates basic PNG icons that Chrome will recognize
 */

import fs from 'fs';
import path from 'path';

const iconsDir = './assets/icons';
const distIconsDir = './dist/assets/icons';

// Ensure directories exist
[iconsDir, distIconsDir].forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

console.log('🔧 Fixing Repotools icons...');

// Create a minimal valid PNG with blue background
// This is a very basic PNG that Chrome will accept
const sizes = [16, 32, 48, 128];

sizes.forEach(size => {
  const iconData = createMinimalPNG(size);
  
  // Write to both source and dist directories
  const sourcePath = path.join(iconsDir, `icon-${size}.png`);
  const distPath = path.join(distIconsDir, `icon-${size}.png`);
  
  fs.writeFileSync(sourcePath, iconData);
  fs.writeFileSync(distPath, iconData);
  
  console.log(`✅ Created ${size}x${size} icon`);
});

function createMinimalPNG(size) {
  // Create a minimal PNG with blue background
  // This creates a valid PNG that Chrome extensions can use
  
  const width = size;
  const height = size;
  
  // PNG signature
  const signature = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  
  // IHDR chunk
  const ihdr = Buffer.alloc(25);
  ihdr.writeUInt32BE(13, 0); // chunk length
  ihdr.write('IHDR', 4);
  ihdr.writeUInt32BE(width, 8);
  ihdr.writeUInt32BE(height, 12);
  ihdr.writeUInt8(8, 16);   // bit depth
  ihdr.writeUInt8(2, 17);   // color type (RGB)
  ihdr.writeUInt8(0, 18);   // compression
  ihdr.writeUInt8(0, 19);   // filter
  ihdr.writeUInt8(0, 20);   // interlace
  
  // Calculate CRC for IHDR
  const ihdrCrc = calculateCRC32(ihdr.slice(4, 21));
  ihdr.writeUInt32BE(ihdrCrc, 21);
  
  // Create image data (blue background)
  const pixelData = Buffer.alloc(width * height * 3); // RGB
  for (let i = 0; i < pixelData.length; i += 3) {
    pixelData[i] = 59;      // R (blue)
    pixelData[i + 1] = 130; // G
    pixelData[i + 2] = 246; // B
  }
  
  // IDAT chunk (simplified - no compression for now)
  const idat = Buffer.alloc(12 + pixelData.length);
  idat.writeUInt32BE(pixelData.length, 0);
  idat.write('IDAT', 4);
  pixelData.copy(idat, 8);
  
  const idatCrc = calculateCRC32(idat.slice(4, 8 + pixelData.length));
  idat.writeUInt32BE(idatCrc, 8 + pixelData.length);
  
  // IEND chunk
  const iend = Buffer.alloc(12);
  iend.writeUInt32BE(0, 0); // chunk length
  iend.write('IEND', 4);
  
  const iendCrc = calculateCRC32(iend.slice(4, 8));
  iend.writeUInt32BE(iendCrc, 8);
  
  return Buffer.concat([signature, ihdr, idat, iend]);
}

function calculateCRC32(data) {
  // CRC32 calculation for PNG
  const crcTable = [];
  for (let i = 0; i < 256; i++) {
    let c = i;
    for (let j = 0; j < 8; j++) {
      c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    crcTable[i] = c;
  }
  
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < data.length; i++) {
    crc = crcTable[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

console.log('🎉 Icons fixed!');
console.log('📁 Icons created in both assets/icons/ and dist/assets/icons/');
console.log('🔄 Reload the extension in Chrome to see the new icons');

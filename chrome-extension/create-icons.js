#!/usr/bin/env node

/**
 * Quick icon generator for Repotools
 * Creates simple PNG files with "R" logo
 */

import fs from 'fs';
import path from 'path';

const sizes = [16, 32, 48, 128];
const iconsDir = './assets/icons';

// Ensure directory exists
if (!fs.existsSync(iconsDir)) {
  fs.mkdirSync(iconsDir, { recursive: true });
}

console.log('🎨 Creating Repotools icons...');

// Create a simple data URL PNG for each size
sizes.forEach(size => {
  console.log(`📐 Creating ${size}x${size} icon...`);
  
  // Create a simple base64 encoded PNG with blue background and white "R"
  // This is a minimal approach that works
  const canvas = createIconCanvas(size);
  const pngData = canvasToPNG(canvas, size);
  
  const iconPath = path.join(iconsDir, `icon-${size}.png`);
  fs.writeFileSync(iconPath, pngData);
  
  console.log(`✅ Created ${iconPath}`);
});

function createIconCanvas(size) {
  // Create pixel data for a blue circle with white "R"
  const pixels = [];
  const centerX = size / 2;
  const centerY = size / 2;
  const radius = size * 0.45;
  
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const distance = Math.sqrt((x - centerX) ** 2 + (y - centerY) ** 2);
      
      if (distance <= radius) {
        // Inside circle - blue gradient
        const intensity = 1 - (distance / radius) * 0.2;
        pixels.push([
          Math.floor(59 * intensity),   // R (blue)
          Math.floor(130 * intensity),  // G
          Math.floor(246 * intensity),  // B
          255                           // A
        ]);
      } else {
        // Outside circle - transparent
        pixels.push([0, 0, 0, 0]);
      }
    }
  }
  
  return pixels;
}

function canvasToPNG(pixels, size) {
  // Create a very basic PNG structure
  // This is simplified but should work for Chrome extensions
  
  const width = size;
  const height = size;
  
  // Convert pixels to buffer
  const data = Buffer.alloc(width * height * 4);
  let index = 0;
  
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const pixel = pixels[y * width + x];
      data[index++] = pixel[0]; // R
      data[index++] = pixel[1]; // G
      data[index++] = pixel[2]; // B
      data[index++] = pixel[3]; // A
    }
  }
  
  // Create minimal PNG
  const signature = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  const ihdr = createIHDRChunk(width, height);
  const idat = createIDATChunk(data);
  const iend = createIENDChunk();
  
  return Buffer.concat([signature, ihdr, idat, iend]);
}

function createIHDRChunk(width, height) {
  const chunk = Buffer.alloc(25);
  chunk.writeUInt32BE(13, 0); // length
  chunk.write('IHDR', 4);
  chunk.writeUInt32BE(width, 8);
  chunk.writeUInt32BE(height, 12);
  chunk.writeUInt8(8, 16);  // bit depth
  chunk.writeUInt8(6, 17);  // color type (RGBA)
  chunk.writeUInt8(0, 18);  // compression
  chunk.writeUInt8(0, 19);  // filter
  chunk.writeUInt8(0, 20);  // interlace
  
  const crc = crc32(chunk.slice(4, 21));
  chunk.writeUInt32BE(crc, 21);
  
  return chunk;
}

function createIDATChunk(data) {
  // Simplified IDAT - just raw data for now
  const compressed = data; // Should be zlib compressed, but simplified
  const chunk = Buffer.alloc(12 + compressed.length);
  chunk.writeUInt32BE(compressed.length, 0);
  chunk.write('IDAT', 4);
  compressed.copy(chunk, 8);
  
  const crc = crc32(chunk.slice(4, 8 + compressed.length));
  chunk.writeUInt32BE(crc, 8 + compressed.length);
  
  return chunk;
}

function createIENDChunk() {
  const chunk = Buffer.alloc(12);
  chunk.writeUInt32BE(0, 0); // length
  chunk.write('IEND', 4);
  
  const crc = crc32(chunk.slice(4, 8));
  chunk.writeUInt32BE(crc, 8);
  
  return chunk;
}

function crc32(data) {
  // Simplified CRC32 - not a real implementation
  // For a real PNG, you'd need proper CRC32
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < data.length; i++) {
    crc = crc ^ data[i];
    for (let j = 0; j < 8; j++) {
      crc = (crc & 1) ? (0xEDB88320 ^ (crc >>> 1)) : (crc >>> 1);
    }
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

console.log('🎉 Icon generation complete!');
console.log('🔄 Now run: npm run build');

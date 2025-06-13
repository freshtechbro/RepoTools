/**
 * Test-specific security configuration utilities
 * 
 * This module provides utilities for configuring the filesystem security
 * system in test environments to prevent path validation issues.
 */

import { FilesystemSecurity } from '../../security/filesystem-security.js';
import path from 'path';
import { tmpdir } from 'os';

/**
 * Configuration for test environment security
 */
export interface TestSecurityConfig {
  allowedDirectories?: string[];
  enablePermissionChecking?: boolean;
  enableBlacklist?: boolean;
  enableExtensionFiltering?: boolean;
  additionalBlacklistedPaths?: string[];
}

/**
 * Default test security configuration
 * More permissive than production to allow test execution
 */
export const DEFAULT_TEST_SECURITY_CONFIG: TestSecurityConfig = {
  allowedDirectories: [
    process.cwd(), // Current working directory (test environment)
    tmpdir(), // System temp directory
    '/tmp', // Unix temp directory
    path.join(tmpdir(), 'vibe-fs-security-test'), // Test-specific temp directory
  ],
  enablePermissionChecking: true,
  enableBlacklist: true,
  enableExtensionFiltering: false, // More permissive for tests
  additionalBlacklistedPaths: []
};

/**
 * Configure filesystem security for test environment
 * 
 * @param config Optional custom configuration, merged with defaults
 * @returns Configured FilesystemSecurity instance
 */
export function configureTestSecurity(config: TestSecurityConfig = {}): FilesystemSecurity {
  const mergedConfig = {
    ...DEFAULT_TEST_SECURITY_CONFIG,
    ...config,
    allowedDirectories: [
      ...(DEFAULT_TEST_SECURITY_CONFIG.allowedDirectories || []),
      ...(config.allowedDirectories || [])
    ]
  };

  return FilesystemSecurity.getInstance(mergedConfig);
}

/**
 * Reset filesystem security to test-friendly defaults
 * Useful in beforeEach hooks
 */
export function resetTestSecurity(): FilesystemSecurity {
  return configureTestSecurity();
}

/**
 * Create a test-specific allowed directory and configure security
 * 
 * @param testName Name of the test (used for directory naming)
 * @returns Object with test directory path and configured security instance
 */
export function createTestEnvironment(testName: string): {
  testDir: string;
  security: FilesystemSecurity;
} {
  const testDir = path.join(tmpdir(), `vibe-test-${testName}-${Date.now()}`);
  
  const security = configureTestSecurity({
    allowedDirectories: [testDir]
  });

  return { testDir, security };
}


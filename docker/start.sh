#!/bin/sh

echo "Starting Kepler.gl setup..."

echo "Patching esbuild config..."

# Create the patch file
cat > /app/examples/demo-app/openURL.mjs << 'EOL'
// SPDX-License-Identifier: MIT
// Copyright contributors to the kepler.gl project

import process from 'node:process';
import {spawn} from 'node:child_process';

export function openURL(url) {
  // Always disable browser opening in Docker
  console.log(`Note: Browser auto-opening disabled in Docker. Access the app at ${url}`);
  return;
}
EOL

# Patch the esbuild config
cd /app/examples/demo-app
echo "Adding import statement..."
sed -i '/import.*child_process/a import {openURL} from "./openURL.mjs";' esbuild.config.mjs

echo "Removing original openURL function..."
sed -i '/function openURL/,/^}/d' esbuild.config.mjs

echo "Starting application..."
cd /app
exec yarn start

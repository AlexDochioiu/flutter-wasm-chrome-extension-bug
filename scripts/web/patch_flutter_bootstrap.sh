#!/bin/bash
# Patch script to make Flutter WASM work with Chrome Extension Manifest V3
#
# Chrome Extension Manifest V3 has strict Content Security Policy (CSP) that blocks:
# - Dynamic script loading via import()
# - Web Workers created with module type
# - Blob URLs for workers
#
# This script modifies Flutter's bootstrap to work around these restrictions by:
# 1. Forcing single-threaded WASM (no workers)
# 2. Disabling crossOriginIsolated features
# 3. Disabling Flutter's service worker registration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_PATH="$SCRIPT_DIR/../../build/web/flutter_bootstrap.js"

# Check if bootstrap file exists
if [ ! -f "$BOOTSTRAP_PATH" ]; then
  echo "flutter_bootstrap.js not found. Run flutter build first."
  exit 1
fi

# Patch 1: Force single-threaded WASM execution
# Changes: skwasmSingleThreaded:!r.crossOriginIsolated||e.forceSingleThreadedSkwasm
# To:      skwasmSingleThreaded:true
# Why:     Multi-threaded WASM uses SharedArrayBuffer and Web Workers with ES modules,
#          which violate Manifest V3 CSP. Single-threaded mode avoids worker creation.
#
# Patch 2: Disable crossOriginIsolated detection
# Changes: crossOriginIsolated:window.crossOriginIsolated
# To:      crossOriginIsolated:false
# Why:     Chrome extensions don't have proper cross-origin isolation, and attempting
#          to use these features causes errors. Setting to false prevents Flutter from
#          trying to use features that require cross-origin isolation.
perl -i.bak -pe '
  # Force single-threaded WASM
  s/skwasmSingleThreaded:!r\.crossOriginIsolated\|\|e\.forceSingleThreadedSkwasm/skwasmSingleThreaded:true/g;

  # Disable crossOriginIsolated
  s/crossOriginIsolated:window\.crossOriginIsolated/crossOriginIsolated:false/g;
' "$BOOTSTRAP_PATH"

# Patch 3: Disable Flutter's service worker registration
# Changes: serviceWorkerSettings: { serviceWorkerVersion: "..." }
# To:      serviceWorkerSettings: null
# Why:     Chrome extensions use the service_worker field in manifest.json instead of
#          navigator.serviceWorker.register(). Flutter's attempt to register a service
#          worker fails with "user denied permission" error in extension context.
#          We set this to null to skip service worker registration entirely.
# Note:    Using -0pe flag to enable slurp mode (read entire file as one string) for
#          multi-line regex matching, as serviceWorkerSettings object spans multiple lines.
perl -i -0pe 's/serviceWorkerSettings:\s*\{[^}]+\}/serviceWorkerSettings: null/gs' "$BOOTSTRAP_PATH"

# Clean up backup file
rm -f "${BOOTSTRAP_PATH}.bak"

echo "✓ Patched flutter_bootstrap.js for Manifest V3 compatibility"
echo "  - Forced single-threaded WASM execution"
echo "  - Disabled crossOriginIsolated features"
echo "  - Disabled Flutter service worker (using manifest.json service_worker instead)"

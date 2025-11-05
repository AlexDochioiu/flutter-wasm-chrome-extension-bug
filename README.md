# Flutter WASM Chrome Extension Bug Report

This project demonstrates that Flutter WASM builds with multi-threaded rendering (skwasm) are incompatible with Chrome Extension Manifest V3 due to Content Security Policy (CSP) restrictions.

## The Issue

Multi-threaded WASM rendering in Flutter uses Web Workers that dynamically import ES modules via `import()`. Chrome Extension Manifest V3 CSP blocks these dynamic imports, even when `cross_origin_embedder_policy` and `cross_origin_opener_policy` headers are set in manifest.json.

**Error:**
```
Uncaught (in promise) TypeError: Failed to fetch dynamically imported module: chrome-extension://[id]/canvaskit/skwasm.js
```

## Environment

- Flutter: 3.35.7 (stable)
- Dart: 3.9.2
- Target: Chrome Extension with Manifest V3
- Build: WASM with CSP compliance

## How to Reproduce

### 1. Build the Extension

```bash
flutter build web --wasm --release --csp --no-tree-shake-icons --no-web-resources-cdn --no-strip-wasm -O0
```

This will create a `build/web` directory with the extension files.

### 2. Load in Chrome (Without Patch - Shows the Bug)

1. Open Chrome and navigate to: `chrome://extensions/`
2. Enable **Developer mode** (toggle in top-right corner)
3. Click **Load unpacked**
4. Select the `build/web` directory
5. Click the extension icon in Chrome toolbar

**Result:** The extension will fail to load with the CSP error mentioned above.

### 3. Apply Workaround Patch

To make it work (at the cost of single-threaded performance):

```bash
sh scripts/web/patch_flutter_bootstrap.sh
```

This patch forces single-threaded WASM execution and disables features that require workers.

### 4. Update Extension in Chrome

1. Go back to `chrome://extensions/`
2. Click the **Update** button (circular arrow icon)
3. Click the extension icon again

**Result:** The extension now works, but without multi-threaded WASM benefits.

## Development Tips

**Inspecting the Extension:**
- Right-click the extension icon in Chrome toolbar
- Select **Inspect Popup**
- This launches the app with DevTools attached

**Updating After Changes:**
1. Rebuild: `flutter build web --wasm --release --csp --no-tree-shake-icons --no-web-resources-cdn --no-strip-wasm -O0`
2. Re-apply patch: `sh scripts/web/patch_flutter_bootstrap.sh`
3. Click **Update** button in `chrome://extensions/`

## Key Files

- **web/manifest.json** - Chrome Extension Manifest V3 with COOP/COEP headers
- **web/index.html** - Extension popup HTML
- **scripts/web/patch_flutter_bootstrap.sh** - Workaround script that forces single-threaded mode

## Expected Behavior

Multi-threaded WASM should work when COOP/COEP headers are properly configured in manifest.json, allowing SharedArrayBuffer and worker-based rendering for better performance.

## Actual Behavior

Dynamic ES module imports (`import()`) used by skwasm workers are blocked by CSP, making multi-threaded WASM impossible in Chrome Extension Manifest V3, even with proper COOP/COEP configuration.

## Workaround Limitations

The patch script forces single-threaded WASM, which:
- ✅ Makes the extension functional
- ❌ Loses multi-threaded performance benefits
- ❌ Defeats the purpose of using WASM for rendering

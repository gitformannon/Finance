# Fix: iOS Simulator Launch Error

## The Problem

**Error:** `Unable to terminate com.mannon.mobileFrontend` with exit code -2

### What's Happening:

1. ✅ **Build succeeds** (25.8s) - Your code compiles fine
2. ❌ **Termination fails** - Flutter tries to kill the old app instance but fails
3. ❌ **Launch fails** - Can't start new instance because old one is stuck

### Root Causes:

1. **App crashed on previous launch** - Left in a bad state
2. **Simulator process stuck** - App process didn't fully terminate
3. **Debug connection conflict** - Previous debug session still active
4. **Simulator state corruption** - Simulator needs reset

## Solutions (Try in Order)

### Solution 1: Force Kill & Reinstall (Recommended)
```bash
# Kill the app process
xcrun simctl terminate 86684E50-5B58-44C3-A198-6284C8D69E2D com.mannon.mobileFrontend

# Uninstall the app completely
xcrun simctl uninstall 86684E50-5B58-44C3-A198-6284C8D69E2D com.mannon.mobileFrontend

# Then run Flutter again
flutter run
```

### Solution 2: Reset Simulator
```bash
# Erase all content and settings
xcrun simctl erase 86684E50-5B58-44C3-A198-6284C8D69E2D

# Or reset from Xcode:
# Xcode → Window → Devices and Simulators → Right-click simulator → Erase All Content and Settings
```

### Solution 3: Restart Simulator
```bash
# Shutdown simulator
xcrun simctl shutdown 86684E50-5B58-44C3-A198-6284C8D69E2D

# Boot it again
xcrun simctl boot 86684E50-5B58-44C3-A198-6284C8D69E2D

# Open Simulator app
open -a Simulator
```

### Solution 4: Clean Build
```bash
# Clean Flutter
flutter clean

# Clean iOS build
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Rebuild
flutter pub get
flutter run
```

### Solution 5: Use Different Simulator
```bash
# List available simulators
flutter devices

# Run on a different one
flutter run -d <device-id>
```

### Solution 6: Kill All Simulator Processes
```bash
# Kill all simulator processes
killall Simulator
killall com.apple.CoreSimulator.CoreSimulatorService

# Wait a few seconds, then restart
open -a Simulator
```

## Quick Fix Script

Save this as `fix_simulator.sh`:
```bash
#!/bin/bash
DEVICE_ID="86684E50-5B58-44C3-A198-6284C8D69E2D"
BUNDLE_ID="com.mannon.mobileFrontend"

echo "Killing app..."
xcrun simctl terminate $DEVICE_ID $BUNDLE_ID 2>/dev/null

echo "Uninstalling app..."
xcrun simctl uninstall $DEVICE_ID $BUNDLE_ID 2>/dev/null

echo "Done! Now run: flutter run"
```

## Prevention

1. **Always stop the app properly** - Use Cmd+Q in simulator or stop Flutter with Ctrl+C
2. **Don't force-quit simulator** - Let it close gracefully
3. **Use hot reload** - Avoid full rebuilds when possible
4. **Keep simulator running** - Don't close it between builds

## Why Exit Code -2?

Exit code `-2` = `SIGINT` (Interrupt signal)
- Means the process was interrupted/killed
- Usually happens when:
  - Process is already dead but not cleaned up
  - Process is stuck and can't respond to termination
  - Simulator is in a bad state

## Still Not Working?

1. **Restart your Mac** - Clears all stuck processes
2. **Update Xcode** - `xcode-select --install`
3. **Check Xcode Console** - Look for crash logs
4. **Try physical device** - Rule out simulator-specific issues


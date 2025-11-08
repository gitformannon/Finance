# iOS Simulator Performance Tips

## Quick Wins:

1. **Use Profile Mode for Testing** (Much Faster)
   ```bash
   flutter run --profile
   ```

2. **Use Release Mode** (Fastest, but no hot reload)
   ```bash
   flutter run --release
   ```

3. **Clean Build Cache**
   ```bash
   flutter clean
   cd ios && pod deintegrate && pod install && cd ..
   flutter pub get
   ```

4. **Use Specific Simulator** (Avoid device detection delay)
   ```bash
   flutter run -d "My iPhone"
   ```

5. **Disable Debugging Features**
   - Close DevTools if not needed
   - Use `--no-sound-null-safety` if applicable

6. **Xcode Build Settings**
   - Open Xcode → Runner → Build Settings
   - Set "Build Active Architecture Only" to YES for Debug
   - Set "Optimization Level" to None [-Onone] for Debug

7. **Reduce Simulator Resources**
   - Use a smaller simulator (iPhone SE instead of iPhone 15 Pro Max)
   - Close other apps on your Mac
   - Increase Mac's available RAM

8. **Use Hot Restart Instead of Full Rebuild**
   - Press 'R' in terminal (hot restart)
   - Press 'r' for hot reload (fastest)

9. **Pre-warm Simulator**
   - Keep simulator running between builds
   - Don't close it after each run

10. **Check for Build Issues**
    ```bash
    flutter doctor -v
    flutter pub get
    cd ios && pod install && cd ..
    ```

## For Development:
- Use **Hot Reload** (r) for UI changes - instant
- Use **Hot Restart** (R) for logic changes - ~2-5 seconds
- Only do **Full Rebuild** when necessary - ~30-60 seconds

## Expected Times:
- First build: 2-5 minutes (normal)
- Subsequent debug builds: 30-60 seconds
- Hot reload: <1 second
- Hot restart: 2-5 seconds
- Profile build: 20-40 seconds
- Release build: 30-60 seconds


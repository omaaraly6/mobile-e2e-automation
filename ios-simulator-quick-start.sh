#!/bin/bash

echo "🚀 iOS Simulator Quick Start Script"
echo "==================================="

# 1. List all available simulators
echo "📋 Available iOS Simulators:"
xcrun simctl list devices available | grep -E "iPhone|iPad"

echo ""
echo "🔍 Finding iPhone 16 simulator..."

# 2. Get the UDID for iPhone 16 (or fallback options)
SIMULATOR_UDID=$(xcrun simctl list devices available | grep "iPhone 16" | head -1 | grep -oE '\([A-F0-9-]{36}\)' | tr -d '()')

if [ -z "$SIMULATOR_UDID" ]; then
    echo "⚠️  iPhone 16 not found, trying fallbacks..."
    
    # Try fallback devices
    FALLBACK_DEVICES=("iPhone 16 Pro" "iPhone 15" "iPhone 15 Pro" "iPhone SE (3rd generation)")
    
    for DEVICE in "${FALLBACK_DEVICES[@]}"; do
        echo "🔍 Trying: $DEVICE"
        SIMULATOR_UDID=$(xcrun simctl list devices available | grep "$DEVICE" | head -1 | grep -oE '\([A-F0-9-]{36}\)' | tr -d '()')
        if [ -n "$SIMULATOR_UDID" ]; then
            echo "✅ Found: $DEVICE"
            break
        fi
    done
    
    if [ -z "$SIMULATOR_UDID" ]; then
        echo "❌ No suitable simulator found!"
        exit 1
    fi
fi

echo "✅ Using simulator UDID: $SIMULATOR_UDID"

# 3. Shutdown any running simulators first
echo "🔄 Shutting down existing simulators..."
xcrun simctl shutdown all

# 4. Boot the simulator
echo "🚀 Booting simulator..."
xcrun simctl boot "$SIMULATOR_UDID"

# 5. Open Simulator app (makes it visible)
echo "📱 Opening Simulator app..."
open -a Simulator

# 6. Wait for simulator to be ready (with multiple detection methods)
echo "⏳ Waiting for simulator to be ready..."
TIMEOUT=60
ELAPSED=0
READY=false

while [ $ELAPSED -lt $TIMEOUT ] && [ "$READY" = false ]; do
    # Method 1: Check boot status
    if xcrun simctl bootstatus "$SIMULATOR_UDID" 2>/dev/null | grep -q "Boot status: Booted"; then
        echo "✅ Simulator booted successfully (bootstatus) in ${ELAPSED} seconds!"
        READY=true
        break
    fi
    
    # Method 2: Check if simulator is in the booted state
    if xcrun simctl list devices | grep "$SIMULATOR_UDID" | grep -q "(Booted)"; then
        echo "✅ Simulator booted successfully (list devices) in ${ELAPSED} seconds!"
        READY=true
        break
    fi
    
    # Method 3: Try to get device info (indicates simulator is responsive)
    if [ $ELAPSED -gt 10 ]; then
        if xcrun simctl spawn "$SIMULATOR_UDID" launchctl print system 2>/dev/null | grep -q "com.apple."; then
            echo "✅ Simulator booted successfully (spawn test) in ${ELAPSED} seconds!"
            READY=true
            break
        fi
    fi
    
    sleep 1
    ELAPSED=$((ELAPSED + 1))
    if [ $((ELAPSED % 10)) -eq 0 ]; then
        echo "⏳ Still waiting... (${ELAPSED}s/${TIMEOUT}s)"
        echo "💡 Tip: If simulator looks ready, press Ctrl+C and continue manually"
    fi
done

if [ "$READY" = false ]; then
    echo "⚠️  Boot detection timed out after ${TIMEOUT} seconds"
    echo "🔍 Current simulator status:"
    xcrun simctl list devices | grep "$SIMULATOR_UDID" || echo "Simulator not found in list"
    echo ""
    echo "📱 If the simulator app is open and shows the home screen, it's probably ready!"
    echo "   You can continue with manual testing or press Enter to proceed anyway..."
    read -p "   Press Enter to continue or Ctrl+C to stop: " -t 10
    echo "✅ Continuing anyway - simulator may be ready"
fi

echo ""
echo "🎉 Simulator is ready!"
echo "UDID: $SIMULATOR_UDID"
echo ""
echo "📋 Quick Commands for Testing:"
echo "# Install an IPA:"
echo "xcrun simctl install $SIMULATOR_UDID /path/to/your/app.ipa"
echo ""
echo "# Launch an app:"
echo "xcrun simctl launch $SIMULATOR_UDID com.zeal.coffeeberry"
echo ""
echo "# Uninstall an app:"
echo "xcrun simctl uninstall $SIMULATOR_UDID com.zeal.coffeeberry"
echo ""
echo "# Grant permissions:"
echo "xcrun simctl privacy $SIMULATOR_UDID grant location com.zeal.coffeeberry"
echo "xcrun simctl privacy $SIMULATOR_UDID grant camera com.zeal.coffeeberry"
echo ""
echo "# Run Maestro tests (from your test directory):"
echo "maestro test . --config config.yaml" 
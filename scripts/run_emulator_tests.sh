#!/bin/bash

# Restart ADB server just in case
echo "Restarting ADB server..."
adb kill-server || true
sleep 2
adb start-server

echo "Waiting for emulator to be listed in adb devices..."
timeout=60
count=0
device_status=""
while [ "$device_status" != "device" ] && [ "$count" -lt "$timeout" ]; do
  sleep 2
  device_status=$(adb devices | grep emulator | awk '{print $2}')
  echo "ADB device status: $device_status"
  count=$((count + 1))
done

if [ "$device_status" != "device" ]; then
  echo "Emulator never showed up in adb devices. Exiting."
  exit 1
fi

echo "Waiting for emulator to finish booting..."
boot_completed=""
count=0
while [ "$boot_completed" != "1" ] && [ "$count" -lt "$timeout" ]; do
  sleep 2
  boot_completed=$(adb -e shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
  echo "sys.boot_completed=$boot_completed"
  count=$((count + 1))
done

if [ "$boot_completed" != "1" ]; then
  echo "Emulator failed to boot in time. Exiting."
  exit 1
fi

echo "Emulator is ready!"

# Retry APK installation up to 5 times in case of failure
for i in $(seq 1 5); do
  echo "Attempting to install APK (try $i)..."
  adb install -r ChallazTopfade.apk && break || {
    echo "⚠️ Install failed, retrying in 5s..."
    sleep 5
  }
done

echo "APK installed"

# Run the Maestro tests
echo "Running Maestro test..."
maestro test android/

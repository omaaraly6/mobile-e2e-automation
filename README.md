# Mobile Automation Maestro Scripts

This repository contains automation scripts for both Android and iOS mobile applications using [Maestro](https://maestro.mobile.dev/).

## Prerequisites

- [Maestro CLI](https://maestro.mobile.dev/getting-started/installation) installed
- Java 11 or higher
- For Android:
  - Android Studio or Android SDK
  - Android emulator or physical device
- For iOS:
  - Xcode (macOS only)
  - iOS simulator or physical device

## Directory Structure

- `android/` - Android automation scripts and configs
- `ios/` - iOS automation scripts and configs
- `scripts/` - Helper shell scripts

## Setup

1. **Install Maestro:**
 ```curl -Ls "https://get.maestro.mobile.dev" | bash ```
 ```export PATH="$PATH:$HOME/.maestro/bin" ```

## Running Maestro Scripts

1. Start an Android/iOS emulator or connect a device.
2. Run a script, for example:

- Android:
  ```maestro test -e appId=com.zeal.XXX android/booking_apps/```
- iOS:
  ```maestro test -e appId=com.zeal.XXX ios/ordering_apps/```

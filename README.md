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

1. **Clone the repository:**
   ```sh
git clone <repo-url>
cd <repo-folder>
```

2. **Install Maestro:**
   ```sh
curl -Ls "https://get.maestro.mobile.dev" | bash
export PATH="$PATH:$HOME/.maestro/bin"
```

3. **(Optional) Add Maestro to your PATH permanently:**
   Add the following line to your `~/.zshrc` or `~/.bash_profile`:
   ```sh
export PATH="$PATH:$HOME/.maestro/bin"
```

## Running Maestro Scripts

### Android

1. Start an Android emulator or connect a device.
2. Run a script, for example:
   ```sh
maestro test android/booking_apps/booking/booking.yaml
```

### iOS

1. Start an iOS simulator or connect a device.
2. Run a script, for example:
   ```sh
maestro test ios/booking_apps/booking/booking.yaml
```

## Example: Run All Booking Scripts

- Android:
  ```sh
maestro test android/booking_apps/booking/*.yaml
```
- iOS:
  ```sh
maestro test ios/booking_apps/booking/*.yaml
```

## Notes
- Ensure your emulator/simulator is running before executing scripts.
- You can modify or add new scripts in the respective `booking_apps` or `ordering_apps` folders.
- For more details, see the [Maestro documentation](https://maestro.mobile.dev/).

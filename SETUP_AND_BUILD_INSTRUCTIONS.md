# Navyla Flight App — Setup & Build Instructions (Phase 1)

This document provides complete instructions for setting up the development environment, configuring project dependencies, and generating release APK and App Bundle files for **Navyla Flight App**.

---

## 1. System Requirements & Prerequisites

Ensure the following tools and SDK versions are installed on your workstation:

| Component | Recommended / Tested Version | Notes |
| :--- | :--- | :--- |
| **Flutter SDK** | `3.24.x` - `3.47.x` (Stable Channel) | Pubspec environment: Dart `^3.12.1` |
| **Dart SDK** | `3.13.x` or higher | Bundled automatically with Flutter |
| **Java Development Kit (JDK)** | OpenJDK `17` | Gradle 9.1 & Android Gradle Plugin compatible |
| **Android SDK** | API Level `34` (Android 14) or higher | Target SDK: 34+, Min SDK: 21+ |
| **Android Studio / VS Code** | Latest version | With Flutter and Dart plugins enabled |
| **Git** | `2.x` or higher | For source control and version matching |

Verify your environment readiness by running:
```bash
flutter doctor -v
```
*(Ensure Android toolchain and Flutter are marked with green checkmarks).*

---

## 2. Project Setup & Dependency Configuration

### Step 1: Clone or Extract the Source Code
If using Git:
```bash
git clone https://github.com/SabbirMo/navyle-flight-app.git
cd navyle-flight-app
```
*Or extract the provided `navyla_flight_app_phase1_source.zip` file into your desired directory.*

### Step 2: Clean Existing Build Cache (Recommended)
Before running the initial build, ensure there are no lingering platform caches:
```bash
flutter clean
```

### Step 3: Fetch Dependencies
Download all project packages and plugins declared in `pubspec.yaml`:
```bash
flutter pub get
```

---

## 3. Running the App in Development Mode

Connect an Android device (with USB debugging enabled) or start an Android Emulator, then run:

```bash
flutter run
```

To run specifically in release mode on a connected device:
```bash
flutter run --release
```

---

## 4. Instructions for Generating the APK

### A. Generate Release APK (Standard universal / fat APK)
To produce a standalone release APK file suitable for testing and sideloading:

```bash
flutter build apk --release
```

* **Output Location:**
  ```text
  build/app/outputs/flutter-apk/app-release.apk
  ```
* **SHA-1 Checksum Location:**
  ```text
  build/app/outputs/flutter-apk/app-release.apk.sha1
  ```

### B. Generate Split-Per-ABI APKs (Optional — Reduced File Size)
If you need smaller, architecture-specific APKs (e.g., `arm64-v8a`, `armeabi-v7a`, `x86_64`):
```bash
flutter build apk --split-per-abi --release
```
*Output will be generated in `build/app/outputs/flutter-apk/` as individual files (e.g., `app-arm64-v8a-release.apk`).*

### C. Generate Android App Bundle (.aab for Google Play Store)
When publishing to the Google Play Console:
```bash
flutter build appbundle --release
```
* **Output Location:**
  ```text
  build/app/outputs/bundle/release/app-release.aab
  ```

---

## 5. Configuration & Platform Details

* **Application Name:** `Navyla`
* **Package Name (Application ID):** `com.example.navyla_flight_app`
* **Java Target Compatibility:** Java 17 (`jvmTarget = "17"`)
* **State Management:** Flutter Riverpod (`3.4.3`)
* **Responsive Layout Engine:** Flutter ScreenUtil (`5.9.3`)
* **Routing:** GoRouter (`18.0.1`)

### Required Permissions Configured in `AndroidManifest.xml`:
* `INTERNET` — Network connectivity for live data services.
* `ACCESS_FINE_LOCATION` & `ACCESS_COARSE_LOCATION` — Airport proximity and indoor navigation.
* `CAMERA` — Ticket and boarding pass scanner.
* `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE` — Uploading documents or profile picture.

---

## 6. Common Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| `Unsupported class file major version` | Incompatible Java version | Ensure `JAVA_HOME` points to JDK 17. |
| `Flutter assets not found` | Incomplete pub get | Run `flutter clean && flutter pub get`. |
| `Gradle sync failed` | Network timeout downloading Gradle 9.1 | Verify internet access or configure proxy in `gradle.properties`. |
| `Execution failed for task ':app:compileReleaseKotlin'` | Cached build state | Run `cd android && ./gradlew clean` then return to root and run `flutter build apk --release`. |

---
*Maintained for Navyla Flight App — Phase 1 Handover.*

You’re hitting iOS **code signing**. Two quick paths:













---

# A) Just run on iOS **Simulator** (no signing needed)

If you only want to see it live while coding:

```bash
# Make sure a simulator is running
open -a Simulator

# List devices (optional)
flutter devices

# Run on simulator
flutter run -d ios
# or build only:
flutter build ios --simulator
```

That’s the fastest way to iterate + hot-reload on iOS.

---

# B) Run on a **real iPhone** (needs signing)

You must sign in to Xcode and select a Team.

1. **Open the Xcode workspace**

```bash
open ios/Runner.xcworkspace
```

2. **Sign in to Xcode**

* Xcode → **Settings…** → **Accounts** → **+** → Sign in with Apple ID

    * Free Apple ID → can run on device (Development)
    * Paid Developer Program ($99/yr) → needed for **release/App Store** builds

3. **Select your Team & unique Bundle ID**

* In the left sidebar: select **Runner** (project) → **Runner** (target)
* **Signing & Capabilities** tab:

    * Check **Automatically manage signing**
    * **Team**: choose your Apple ID (Personal Team or Company Team)
    * **Bundle Identifier**: make it unique (e.g. `com.yourorg.riTracker`)

4. **Plug your iPhone in**

* Trust the computer on the phone, and in Xcode: Product → **Run** (⌘R)
* If iOS asks to trust the developer: iPhone **Settings → General → VPN & Device Management → Developer App → Trust**

> This lets you launch **Debug** builds on your device and hot-reload from IntelliJ/terminal.

---

# C) Build a **Release** for TestFlight / App Store

This requires a **paid** Apple Developer account.

1. Make sure step B is done (Team set, unique bundle).
2. In Xcode (with `Runner.xcworkspace` open):

    * **Product → Archive**
    * After archiving, **Distribute App** → App Store Connect → **Upload**
    * Use **Automatic signing** (recommended). Xcode will create a Distribution certificate & Provisioning Profile.
3. Alternatively via Flutter CLI (still needs signing set in Xcode):

```bash
flutter build ipa --release
```

---

## Extra setup you may need once on macOS

**CocoaPods**

```bash
# If pods aren’t installed yet:
brew install cocoapods   # or: sudo gem install cocoapods
cd ios
pod repo update
pod install
cd ..
```

**Min iOS target**
Your log shows Flutter upgraded to iOS 13 automatically; confirm in:

* Xcode → Runner target → **Build Settings** → **iOS Deployment Target** = **13.0**.

---

## Common gotchas & fixes

* **“No valid code signing certificates were found”**
  → You haven’t added an Apple ID/Team in Xcode, or Bundle ID isn’t unique. Do step B(2)-(3).

* **You only need a release .ipa later**
  For local build without signing (e.g., CI or to hand off):

  ```bash
  flutter build ios --release --no-codesign
  ```

  (You’ll still need to sign/archive with Xcode to ship.)

* **Scheme/Workspace**
  Always open `ios/Runner.xcworkspace` (not the `.xcodeproj`).

* **Device not showing**
  In Xcode’s toolbar, pick your plugged-in iPhone and “Resolve issues” if Xcode offers a Fix.

---

### TL;DR

* For quick live testing: **use iOS Simulator** → `open -a Simulator` → `flutter run -d ios`.
* For a real iPhone: open `Runner.xcworkspace` → **Accounts** (add Apple ID) → **Signing** (Team + unique Bundle ID) → **Run**.
* For App Store/TestFlight: join paid program → **Archive** in Xcode → **Distribute**.

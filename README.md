# Bushy iOS 🌿

Native iOS application for **Bushy** — an interactive fitness companion featuring an organic reactive avatar, daily missions, live pedometer step tracking, and multilingual Indian food nutrition analysis powered by Kotlin Multiplatform (KMP).

---

## 📱 Features

- **Reactive Bushy Mascot**: Organic vector cloud body driven by Catmull-Rom cubic splines, natural blinking animations, and spring bounce tap interactions.
- **Level & Progression System**: Dynamic XP calculations, leveling curve, daily streak tracking (`🔥 1d`), and progress indicators.
- **Daily Missions (Tasks)**:
  - Task types: `STEPS`, `PUSHUPS`, `WATER`, and `GENERAL`.
  - Filters: `All`, `Active`, `Done`.
  - Tap-to-progress, reset, and mission deletion.
  - Floating Action Button with presets for quick mission creation.
- **Live Phone Pedometer**:
  - `CMPedometer` integration (`CoreMotion`) for automatic background and foreground step counting.
  - Real-time step and XP synchronization.
  - Manual step simulator support for Xcode Simulator testing.
- **Multilingual Nutrition & Food Logging**:
  - Shared Kotlin Multiplatform logic via `Shared.framework`.
  - 40+ Indian ICMR nutrition items with macros (Protein, Carbs, Fats, Calories).
  - Multilingual script recognition supporting Hindi (Devanagari), Tamil, Gujarati, and English transliterations.

---

## 🛠 Tech Stack

- **Language**: Swift 5.9+ / SwiftUI
- **Architecture**: MVVM with reactive `ObservableObject` state
- **Core Frameworks**: SwiftUI, Combine, CoreMotion (`CMPedometer`)
- **Cross-Platform**: Kotlin Multiplatform (`Shared.framework` embedded in `Frameworks/`)

---

## 🚀 Getting Started

1. Open `BushyiOS.xcodeproj` in **Xcode 16+**.
2. Select your desired simulator or connected physical iOS device (e.g., iPhone 16 / iPhone 17 / iPhone 18 Pro).
3. Press **Cmd + R** to build and run.
